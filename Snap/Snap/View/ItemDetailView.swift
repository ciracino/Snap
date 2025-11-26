import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var rentalRequestViewModel: RentalRequestViewModel
    @EnvironmentObject var userListViewModel: UserListViewModel
    @EnvironmentObject var viewModel: ItemViewModel
    
    @Binding var path: NavigationPath
    
    let id: String
    
    var body: some View {
        VStack(spacing: 0) {
            if let item = viewModel.items.first(where: { $0.id == id }) {
                ScrollView(showsIndicators: false) {
                    // 아이템 이미지
                    AsyncImage(url: URL(string: item.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        case .failure(let error):
                            Image(systemName: "xmark")
                        }
                    }
                    
                    // 아이템 이름, 수량
                    VStack {
                        HStack {
                            Text("\(item.name)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack {
                            Text("\(item.quantity)")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // 아이템 대여자 목록
                    LazyVStack {
                        HStack {
                            Text("대여자")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        ForEach(item.requests, id: \.self) { requestId in
                            HStack {
                                Text("\(getUserNameFromRequestId(requestId: requestId))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    
                    
                }
                Spacer()
                if let user = authViewModel.currentUserInfo {
                    if !user.isAdmin {
                        VStack(spacing: 0) {
                            Divider()
                                .padding(.top, 20)
                            
                            // 하단 고정 대여 버튼
                            Button {
                                let requestId = UUID().uuidString
                                
                                // requests 에 데이터 저장
                                rentalRequestViewModel.createRequest(itemId: item.id, requestId: requestId)
                                
                                // 유저 정보 업데이트
                                if let userInfo = authViewModel.currentUserInfo {
                                    rentalRequestViewModel.updateUserRequests(userInfo: userInfo, requestId: requestId)
                                }
                                path.removeLast()
                            } label: {
                                HStack {
                                    Image(systemName: "bag.fill")
                                        .font(.title2)
                                    Text("대여하기")
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
                            .disabled(item.quantity == 0)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .background(Color(.systemBackground))
                    }
                }
            } else {
                Text("해당 아이템을 찾지 못했습니다.")
            }
        }
        .padding()
    }
    
    private func getUserNameFromRequestId(requestId: String) -> String {
        if let userId = rentalRequestViewModel.returnUserId(requestId: requestId) {
            if let userInfo = userListViewModel.returnUserInfo(userId: userId) {
                return userInfo.name
            }
        }
        return "일치하는 유저가 없습니다."
    }
}
