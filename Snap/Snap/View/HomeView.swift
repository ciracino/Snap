import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var itemVM: ItemViewModel
    @State private var path = NavigationPath()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack(spacing: 16) {
                if let user = authVM.currentUserInfo {
                    HomeViewHeader(path: $path, user: user)
                }
            }
            .padding(20)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .selectItemView:
                    SelectItemView(path: $path)
                case .writeItemInfoView:
                    WriteItemInfoView(path: $path)
                }
            }
            HomeViewBody()
                .environmentObject(itemVM)
        }
    }
}

enum Destination: Hashable {
    case selectItemView
    case writeItemInfoView
}
