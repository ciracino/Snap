import SwiftUI

struct StudentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var selectedTab = 0
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                // 메인 페이지
                switch selectedTab {
                case 1: StudentRequestView()
                case 2: StudentWriteBoardView()
                case 3: AdminUserListView()
                default: HomeView()
                }
                Spacer()
                // 하단부 탭바
                CustomTabBar(isAdmin: false, selectedTab: $selectedTab)
            }
            .navigationDestination(for: StudentRoute.self) { route in
                switch route {
                case .requestView:
                    StudentRequestView()
                case .itemDetailView(let id):
                    ItemDetailView(path: $path, id: id)
                case .writeBoardView:
                    StudentWriteBoardView()
                
                default:
                    Text("미구현")
                }
            }
        }
    }
}

// 관리자 페이지에서 사용할 네비게이션 패스 경로를 정의
enum StudentRoute: Hashable {
    case requestView // 대여 요청 페이지
    case writeBoardView // 게시글 작성 페이지
    case boardListView // 게시물 목록 페이지
    case itemDetailView(String) // 아이템 상세 정보 페이지
}

