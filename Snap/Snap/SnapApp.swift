

import SwiftUI
import FirebaseCore

@main
struct SnapApp: App {

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AuthViewModel())
        }
    }
}
