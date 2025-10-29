struct Item: Identifiable {
    let id: String
    var name: String
    var quantity: Int
    var imageURL: String
    
    init(id: String, name: String, quantity: Int, imageURL: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.imageURL = imageURL
    }
    
    init?(from data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? "item"
        self.quantity = data["quantity"] as? Int ?? 0
        self.imageURL = data["imageURL"] as? String ?? ""
    }
}

extension Item {
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
