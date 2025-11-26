import SwiftUI

struct AdminView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var selectedTab = 0
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                // 메인 페이지
                switch selectedTab {
                case 1: AdminRequestView()
                case 2: AdminSelectItemView(path: $path)
                case 3: AdminUserListView()
                default: HomeView()
                }
                Spacer()
                // 하단부 탭바
                CustomTabBar(isAdmin: true, selectedTab: $selectedTab)
            }
            .navigationDestination(for: AdminRoute.self) { route in
                switch route {
                case .requestView:
                    AdminRequestView()
                case .requestDetailView(let id):
                    AdminRequestDetailView(id: id)
                case .selectItemView:
                    SelectItemView(path: $path)
                case .writeItemInfoView:
                    AdminWriteItemInfoView(path: $path)
                case .userListView:
                    AdminUserListView()
                case .itemDetailView(let id):
                    ItemDetailView(path: $path, id: id)
                default:
                    Text("미구현")
                }
            }
        }
    }
}

// 관리자 페이지에서 사용할 네비게이션 패스 경로를 정의
enum AdminRoute: Hashable {
    case requestView // 대여 요청 페이지
    case requestDetailView(String) // 대여 요청 상세 페이지
    case selectItemView // 아이템 사진 선택
    case writeItemInfoView // 선택한 아이템 정보 입력
    case userListView // 유저 관리 페이지
    case itemDetailView(String) // 아이템 상세 정보 페이지
}
