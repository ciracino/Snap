import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseRepository {
    static let shared = FirebaseRepository()
    
    @Published var currentUserUID = ""
    @Published var currentUploadImageURL = ""
    @Published var currentUserInfo: UserInfo?
    
    var fetchedItems: [Item] = []
    var fetchedUsers: [UserInfo] = []
    var fetchedRentalRequests: [RentalRequest] = []
    
    let auth = Auth.auth()
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    // 회원가입 (only student)
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            }
            
            if let user = result?.user {
                self.currentUserUID = user.uid
                completion(true)
            }
        }
    }
    
    // 로그인
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            }
            
            if let user = result?.user {
                self.currentUserUID = user.uid
                completion(true)
            }
        }
    }
    
    // 로그아웃
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            self.currentUserUID = ""
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    // 이미지 파일을 스토리지에 업로드
    func uploadImage(imageData: Data, completion: @escaping (Bool) -> Void) {
        let uuid = UUID().uuidString
        let ref = storage.reference().child("images/\(uuid).jpg")
        
        let _ = ref.putData(imageData, metadata: nil) { metadata, errer in
            guard let _ = metadata else {
                completion(false)
                return
            }
            
            ref.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(false)
                    return
                }
                self.currentUploadImageURL = downloadURL.absoluteString
                print("File uploaded to: \(downloadURL)")
                completion(true)
            }
        }
    }
    
    // UserInfo 객체를 스토어에 저장
    func saveUserInfo(data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("users").document(currentUserUID).setData(data) { error in
            if let error = error {
                print("Error writing document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // 스토어로부터 userInfo 정보를 가져옴
    func fetchUserInfo(uid: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(false)
            } else if let document = document, document.exists {
                self.currentUserInfo = UserInfo(from: document.data()!)
                completion(true)
            }
        }
    }
    
    // 생성한 아이템 정보를 저장
    func saveItemInfo(item: Item, path: String, completion: @escaping (Bool) -> Void) {
        db.collection("items").document(path).setData(item.toDictionary()) { error in
            if let error = error {
                print("아이템 정보 저장 중 오류 발생: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // 유저의 아이템 정보를 불러옴
    func fetchItems(completion: @escaping (Bool) -> Void) {
        // 배열 초기화
        fetchedItems = []
        db.collection("items").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.fetchedItems = snapshot!.documents.compactMap { dictionary in
                        Item(from: dictionary.data())
                    }
                    print("아이템 정보를 읽어오는데 성공하였습니다")
                    completion(true)
                }
            }
        }
    }
    
    // 모든 유저 정보를 읽어오기
    func fetchUsers(completion: @escaping (Bool) -> Void) {
        // 배열 초기화
        fetchedUsers = []
        db.collection("users").getDocuments() { (snapshot, error) in
            if let _ = error {
                print("유저 정보를 읽어오는데 실패하였습니다.")
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.fetchedUsers = snapshot!.documents.compactMap { dictionary in
                        UserInfo(from: dictionary.data())
                    }
                    print("유저 정보를 읽어오는데 성공하였습니다.")
                    completion(true)
                }
            }
        }
    }
    
    // 물품 대여 요청을 DB에서 불러옴
    func fetchRentalRequests(completion: @escaping (Bool) -> Void) {
        // 배열 초기화
        fetchedRentalRequests = []
        db.collection("requests").getDocuments() { (snapshot, error) in
            if let _ = error {
                print("대여 정보를 읽어오는데 실패하였습니다.")
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.fetchedRentalRequests = snapshot!.documents.compactMap { dictionary in
                        RentalRequest(from: dictionary.data())
                    }
                    print("대여 정보를 읽어오는데 성공하였습니다.")
                    completion(true)
                }
            }
        }
    }
    
    // 물품 대여 요청을 DB에 저장
    func saveRentalRequest(data: [String: Any], path: String, completion: @escaping (Bool) -> Void) {
        // 1. request 저장
        db.collection("requests").document(path).setData(data) { error in
            if let error = error {
                print("대여 요청 정보 저장 중 오류 발생: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateItem(item: Item, completion: @escaping (Bool) -> Void) {
        // 아이템 정보 업데이트
        let itemData = item.toDictionary()
        db.collection("items").document(item.id).setData(itemData, merge: true) { error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateUserInfo(data: [String: Any], userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).setData(data, merge: true) { error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateRequests(data: [String: Any], requestId: String, completion: @escaping (Bool) -> Void) {
        db.collection("requests").document(requestId).setData(data, merge: true) { error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
