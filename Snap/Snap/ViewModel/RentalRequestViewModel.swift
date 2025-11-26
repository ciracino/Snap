import SwiftUI

class RentalRequestViewModel: ObservableObject {
    let repo = FirebaseRepository.shared
    
    @Published var rentalRequests: [RentalRequest] = []
    
    init() {
        fetchRentalRequests()
    }
    
    func fetchRentalRequests() {
        repo.fetchRentalRequests { result in
            if result {
                self.rentalRequests = self.repo.fetchedRentalRequests
                for request in self.rentalRequests {
                    print("requestsId: \(request.id)")
                    print("statusCode: \(request.rentalStatus)")
                }
            } else {
                print("아이템 로드 실패")
            }
        }
    }
    
    func createRequest(itemId: String, requestId: String) {
        // 1. requests 에 저장
        let request = RentalRequest(id: requestId, itemId: itemId, userId: repo.currentUserUID, rentalStatus: 0)
        repo.saveRentalRequest(data: request.toDictionary(), path: requestId) { result in
            if result {
                self.fetchRentalRequests()
                print("대여 요청 정보를 저장하는데 성공!")
            } else {
                print("대여 요청 정보를 저장하는데 실패했습니다.")
            }
        }
    }
    
    func updateUserRequests(userInfo: UserInfo, requestId: String) {
        var newUserInfo = userInfo
        newUserInfo.requests.append(requestId)
        repo.updateUserInfo(data: newUserInfo.toDictionary(), userId: userInfo.id) { result in
            if result {
                print("updateUserRequests: \(userInfo.name)님의 requests 업데이트 성공!")
            } else {
                print("updateUserRequests: \(userInfo.name)님의 requests 업데이트 실패")
            }
        }
    }
    
    // 대여 요청을 승인 : 상태 코드 1 반환
    func acceptRequest(request: RentalRequest) {
        var newRequest = request
        newRequest.rentalStatus = 1
        repo.updateRequests(data: newRequest.toDictionary(), requestId: request.id) { result in
            if result {
                self.fetchRentalRequests()
                print("acceptRequest: requests 승인 성공!")
            } else {
                print("acceptRequest: requests 승인 실패!")
            }
        }
    }
    
    // 코드 값에 따라 상태 텍스트 반환
    func returnRentalStatus(statusCode: Int) -> String {
        switch statusCode {
        case 0:
            return "승인 대기 중"
        case 1:
            return "대여 중"
        case 2:
            return "대여 거부"
        case 3:
            return "연체 중"
        default:
            return "승인 대기 중"
        }
    }
    
    // 상위 뷰에서 받은 아이디로 대여 요청 값을 조회하여 반환
    func returnRentalRequest(requestId: String) -> RentalRequest? {
        let result = rentalRequests.first(where: { $0.id == requestId })
        return result
    }
    
    func returnUserId(requestId: String) -> String? {
        if let request = self.rentalRequests.first(where: { $0.id == requestId }) {
            return request.userId
        }
        return nil
    }
}
