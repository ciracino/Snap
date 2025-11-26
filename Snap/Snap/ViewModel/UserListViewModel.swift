import SwiftUI

class UserListViewModel: ObservableObject {
    @Published var users: [UserInfo] = []
    
    let repo = FirebaseRepository.shared
    
    init() {
        fetchUsers()
    }
    
    // 모든 유저의 정보를 읽어옴
    func fetchUsers() {
        repo.fetchUsers { result in
            if result {
                print("\(self.repo.fetchedUsers.count)명의 유저 정보 로드")
                self.users = self.repo.fetchedUsers
            } else {
                print("유저 정보 로드 실패")
            }
        }
    }
    
    // 유저 아이디 받아서 유저 반환
    func returnUserInfo(userId: String) -> UserInfo? {
        if let user = self.users.first(where: { $0.id == userId }) {
            return user
        } else {
            print("returnUserInfo: 일치하는 유저가 없습니다.")
        }
        return nil
    }
}
