import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            HomeView()
                .environmentObject(ItemViewModel())
        } else {
            AuthView()
        }
    }
}
