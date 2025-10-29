struct UserInfo: Identifiable {
    let id: String
    var name: String
    var imageURL: String
    var overdueCount: Int = 0 // 연체 횟수
    var isAdmin: Bool = false // 사용자가 학생인지, 관리자인지 구분하는 플래그
    
    init(id: String, name: String, imageURL: String, isAdmin: Bool) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.isAdmin = isAdmin // 관리자로 계정 생성시 플래그를 체크하면 true
    }
    
    // 스토어에서 데이터를 읽어올 때 사용할 생성자
    init?(from data: [String: Any]) {
        self.id = data["id"] as? String ?? "" // id 필드값을 String 타입으로 가져온다. 일치값이 없으면 "" 를 반환
        self.name = data["name"] as? String ?? "user"
        self.imageURL = data["imageURL"] as? String ?? ""
        self.overdueCount = data["overdueCount"] as? Int ?? 0
        self.isAdmin = data["isAdmin"] as? Bool ?? false
    }
}

// 회원가입 절차로 userinfo 객체를 생성하고, 스토어에 객체를 저장할 때 이용.
extension UserInfo {
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
