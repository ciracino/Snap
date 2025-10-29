import SwiftUI

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    @Published var createdItemName = ""
    @Published var createdItemQuantity = ""
    @Published var createdItemImage: UIImage?
    
    @Published var isLoading = false
    
    
    let repo = FirebaseRepository.shared
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        repo.fetchItems { result in
            if result {
                print("\(self.repo.fetchedItems.count)개의 아이템 로드")
                self.items = self.repo.fetchedItems
            } else {
                print("아이템 로드 실패")
            }
        }
    }
    
    func createItem() {
        // 예외 처리 스킵
        
        // 이미지 업로드 먼저
        saveItemImage { result in
            if result {
                let path = UUID().uuidString
                let newItem = Item(id: UUID().uuidString, name: self.createdItemName, quantity: self.convertItemQuantity() , imageURL: self.repo.currentUploadImageURL)
                self.repo.saveItemInfo(data: newItem.toDictionary(), path: path) { result in
                    if result {
                        print("아이템 정보를 저장하는데 성공했습니다.")
                    } else {
                        print("아이템 정보를 저장하는데 실패하였습니다.")
                    }
                }
            } else {
                print("아이템 이미지를 저장하는데 실패하였습니다.")
            }
        }
    }
    
    func saveItemImage(completion: @escaping (Bool) -> Void) {
        guard let image = createdItemImage, let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("이미지를 선택하지 않았거나, 이미지 데이터 변환에 실패하였습니다.")
            completion(false)
            return
        }
        
        repo.uploadImage(imageData: imageData) { result in
            if result {
                print("아이템 이미지 업로드에 성공하였습니다.")
                completion(true)
            } else {
                print("아이템 이미지 업로드에 실패하였습니다.")
                completion(false)
            }
        }
    }
    
    private func convertItemQuantity() -> Int {
        let result = Int(self.createdItemQuantity) ?? 0
        return result
    }
}
