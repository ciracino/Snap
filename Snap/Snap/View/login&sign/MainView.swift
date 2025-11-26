import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        // 로그인 여부 확인 후
        if viewModel.isLoggedIn {
            // 기능 상 하단 탭바의 종류가 다르기 때문에 관리자뷰와 학생뷰를 나눔
            if let user = viewModel.currentUserInfo {
                // 관리자일 경우
                if user.isAdmin {
                    AdminView()
                        .environmentObject(ItemViewModel())
                        .environmentObject(RentalRequestViewModel())
                        .environmentObject(UserListViewModel())
                }
                
                // 학생일 경우
                else {
                    StudentView()
                        .environmentObject(ItemViewModel())
                        .environmentObject(RentalRequestViewModel())
                        .environmentObject(UserListViewModel())
                }
            }
        } else {
            AuthView()
        }
    }
}
