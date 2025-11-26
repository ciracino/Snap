import SwiftUI

struct Item: Identifiable, Equatable {
    let id: String
    var name: String
    var quantity: Int
    var imageURL: String
    var requests: [String] = [] // 대여 요청 아이디를 저장
    
    init(id: String, name: String, quantity: Int, imageURL: String, requests: [String]) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.imageURL = imageURL
        self.requests = requests
    }
    
    init?(from data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? "item"
        self.quantity = data["quantity"] as? Int ?? 0
        self.imageURL = data["imageURL"] as? String ?? ""
        self.requests = data["requests"] as? [String] ?? []
    }
}

extension Item {
    func convertToItem() -> Item {
        let item = Item(id: id, name: name, quantity: quantity, imageURL: imageURL, requests: requests)
        return item
    }
    
    func toDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dictionary: [String: Any] = [:]
        
        for (label, value) in mirror.children {
            guard let key = label else {
                continue
            }
            
            dictionary[key] = value
        }
        
        return dictionary
    }
}
