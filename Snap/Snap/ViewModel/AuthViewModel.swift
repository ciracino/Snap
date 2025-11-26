import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var selectedImage: UIImage?
    
    @Published var isLoading: Bool = false
    @Published var isAdmin: Bool = false
    
    @Published var currentUserUID = ""
    @Published var currentUserInfo: UserInfo?
    
    let repo = FirebaseRepository.shared
    
    init() {
        self.fetchUser { result in
            if result {
                print("\(self.currentUserUID) 로 로그인하였습니다.")
                self.fetchUserInfo()
                self.isLoggedIn.toggle()
            } else {
                print("유저 정보 불러오기 실패")
            }
        }
    }
    
    func fetchUserInfo() {
        repo.fetchUserInfo(uid: currentUserUID) { result in
            if result {
                if let currentUser = self.repo.currentUserInfo {
                    self.currentUserInfo = currentUser
                    self.isAdmin = currentUser.isAdmin
                }
                print("userInfo 업데이트 완료")
            } else {
                print("UserInfo 로드에 실패하였습니다.")
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        isLoading.toggle()
        if let user = repo.auth.currentUser {
            self.repo.currentUserUID = user.uid
            self.currentUserUID = user.uid
            isLoading.toggle()
            completion(true)
        } else {
            isLoading.toggle()
            completion(false)
        }
    }
    
    
    // 유저만 회원가입, 관리자는 FireStore 에서 isAdmin 값을 true 로 수동변경해주기
    func signUp() {
        isLoading.toggle()
        if email == "" || password == "" {
            print("이메일과 패스워드를 입력해주세요")
            return
        }
        repo.signUp(email: email, password: password) { result in
            if result {
                self.currentUserUID = self.repo.currentUserUID
                // 이미지 업로드
                self.saveImage() { result in
                    if result {
                        // 이미지 url 을 가져오자
                        let imageURL = self.repo.currentUploadImageURL
                        let userName = self.email.components(separatedBy: "@")[0]
                        let newUserInfo = UserInfo(id: self.currentUserUID, name: userName, imageURL: imageURL, isAdmin: false, requests: []).toDictionary()
                        print(newUserInfo)
                        self.repo.saveUserInfo(data: newUserInfo) { result in
                            if result {
                                print("회원가입 및 이미지 업로드 성공")
                                // userInfo 업데이트 및 화면 전환
                                self.fetchUserInfo()
                                self.isLoading.toggle()
                                self.isLoggedIn.toggle()
                            } else {
                                print("회원가입 및 이미지 업로드 실패")
                                self.isLoading.toggle()
                            }
                        }
                    } else {
                        print("이미지 업로드 실패")
                        self.isLoading.toggle()
                    }
                }
            } else {
                print("회원가입 실패!")
                self.isLoading.toggle()
            }
        }
    }
    
    // isAdmin 에 따라 관리자 로그인과 사용자 로그인을 나눔
    func signIn() {
        repo.signIn(email: email, password: password) { result in
            if result {
                self.currentUserUID = self.repo.currentUserUID
                // userInfo 업데이트 및 화면 전환
                self.fetchUserInfo()
                self.isLoggedIn.toggle()
            } else {
                print("로그인 실패!")
            }
        }
    }
    
    func signOut() {
        isLoading.toggle()
        
        repo.signOut { result in
            if result {
                print("로그아웃 성공")
                self.isLoading.toggle()
                self.isLoggedIn.toggle()
            } else {
                self.isLoading.toggle()
                print("로그아웃 실패")
            }
        }
    }
    
    func saveImage(completion: @escaping (Bool) -> Void) {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.7) else  {
            print("이미지를 선택하지 않았거나, 이미지 데이터 변환에 실패하였습니다.")
            return
        }
        
        repo.uploadImage(imageData: imageData) { result in
            if result {
                print("이미지 업로드 성공")
                completion(true)
                return
            } else {
                print("이미지 업로드 실패")
                completion(false)
            }
        }
    }
}
