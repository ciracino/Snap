import SwiftUI

struct AdminRequestDetailView: View {
    @EnvironmentObject var viewModel: RentalRequestViewModel
    @EnvironmentObject var itemViewModel: ItemViewModel
    @EnvironmentObject var userListViewModel: UserListViewModel
    
    let id: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let request = viewModel.returnRentalRequest(requestId: id) {
                // 유저 정보를 먼저 나열
                VStack(spacing: 16) {
                    HStack {
                        Text("대여자")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    if let user = userListViewModel.returnUserInfo(userId: request.userId) {
                        HStack {
                            Text("\(user.name)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack {
                            Text("연체 횟수: \(user.overdueCount)회")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
                
                Divider()
                VStack(spacing: 16) {
                    HStack {
                        Text("요구 사항")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    if let item = itemViewModel.returnItemInfo(itemId: request.itemId) {
                        HStack {
                            Text("\(item.name)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack {
                            Text("수량: 1개")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        HStack {
            Button {
                if let request = viewModel.returnRentalRequest(requestId: id) {
                    viewModel.acceptRequest(request: request) // 요구 사항의 상태 코드를 1로 변경
                    // 아이템의 requests 에 대여 요청 아이디 값을 저장하자.
                    if let item = itemViewModel.returnItemInfo(itemId: request.itemId) {
                        // 아이디 저장하고 수량 감소
                        itemViewModel.updateItemRequests(itemId: item.id, requestId: id)
                    } else {
                        print("rentalAccept: 아이템이 없습니다.")
                    }
                } else {
                    print("rentalAccept: 대여 요청이 없습니다.")
                }
            } label: {
                HStack {
                    Text("승인")
                        .font(.title3.bold())
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
            }
            Button {
                
            } label: {
                HStack {
                    Text("거부")
                        .font(.title3.bold())
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.red, Color.red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .red.opacity(0.4), radius: 10, y: 5)
            }
        }
        .padding()
    }
}
