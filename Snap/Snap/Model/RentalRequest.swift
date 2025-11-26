import SwiftUI

struct RentalRequest: Identifiable, Equatable {
    let id: String
    var itemId: String
    var userId: String
    var rentalStatus: Int
    
    init(id: String, itemId: String, userId: String, rentalStatus: Int) {
        self.id = id
        self.itemId = itemId
        self.userId = userId
        self.rentalStatus = rentalStatus
    }
    
    init?(from data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.itemId = data["itemId"] as? String ?? "itemId"
        self.userId = data["userId"] as? String ?? "userId"
        self.rentalStatus = data["rentalStatus"] as? Int ?? 0
    }
}

extension RentalRequest {
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
