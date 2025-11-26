import SwiftUI

struct Header: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSignOutView: Bool = false
    
    var body: some View {
        if let user = viewModel.currentUserInfo {
            HStack {
                AsyncImage(url: URL(string: user.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    case .failure:
                        Text("No Image")
                    @unknown default:
                        Image("exclamationmark.icloud.fill")
                            .foregroundStyle(.red)
                    }
                }
                Text(user.isAdmin ? "👑 \(user.name)" : "\(user.name)") // 관리자는 인증 마크를 주자.
                    .fontWeight(.bold)
                    .font(.headline)
                Spacer()
                
                Button {
                    showSignOutView.toggle()
                } label: {
                    Image(systemName: "power")
                        .foregroundStyle(.red)
                        .fontWeight(.bold)
                }
                .alert("", isPresented: $showSignOutView) {
                    Button("로그아웃") {
                        viewModel.signOut()
                    }
                    .foregroundStyle(.red)
                    Button("취소", role: .cancel) {
                        return
                    }
                } message: {
                    Text("로그아웃 하시겠습니까?")
                }
            }
            .padding()
        }
    }
}

