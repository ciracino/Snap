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
    
    // 아이템 정보를 저장
    func saveItemInfo(data: [String: Any], path: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(currentUserUID).collection("items").document(path).setData(data) { error in
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
        db.collection("users").document(currentUserUID).collection("items").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                DispatchQueue.main.async {
                    self.fetchedItems = snapshot!.documents.compactMap { dictionary in
                        Item(from: dictionary.data())
                    }
                    print(self.fetchedItems.count)
                    completion(true)
                }
            }
        }
    }
}
