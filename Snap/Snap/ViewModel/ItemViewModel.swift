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
                self.items = self.repo.fetchedItems.compactMap {
                    $0.convertToItem()
                }
            } else {
                print("아이템 로드 실패")
            }
        }
    }
    
    func createItem() {
        
        // 이미지 업로드 먼저
        saveItemImage { result in
            if result {
                let id = UUID().uuidString
                let newItem = Item(id: id, name: self.createdItemName, quantity: self.convertItemQuantity(), imageURL: self.repo.currentUploadImageURL, requests: [])
                self.repo.saveItemInfo(item: newItem, path: id) { result in
                    if result {
                        // UI 업데이트
                        self.fetchItems()
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
    
    // 대여 요청 승인이 나면, requests 에 대여 요청 아이디 저장. 아이템 수량 감소
    func updateItemRequests(itemId: String, requestId: String) {
        if var newItem = items.first(where: { $0.id == itemId} ) {
            newItem.requests.append(requestId)
            newItem.quantity -= 1
            repo.updateItem(item: newItem) { result in
                if result {
                    self.fetchItems()
                    print("updateItemRequests: 아이템 정보 업데이트 완료!")
                } else {
                    print("updateItemRequests: 아이템 정보 업데이트 실패.")
                }
            }
        } else {
            print("updateItemRequests: 일치하는 아이템을 찾지 못했습니다.")
        }
    }
    
    // 아이템 아이디와 일치하는 아이템 정보를 반환
    func returnItemInfo(itemId: String) -> Item? {
        if let item = self.items.first(where: { $0.id == itemId }) {
            return item
        } else {
            print("returnItemInfo: 일치하는 아이템이 없습니다.")
        }
        return nil
    }
    
    private func convertItemQuantity() -> Int {
        let result = Int(self.createdItemQuantity) ?? 0
        return result
    }
}
