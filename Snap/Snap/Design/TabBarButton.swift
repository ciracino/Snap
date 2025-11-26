import SwiftUI

struct TabBarButton: View {
    @Binding var selectedTab: Int
    
    let buttonUnselected: String
    let buttonSelected: String
    let buttonTitle: String
    let index: Int
    
    var body: some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 8) {
                Image(systemName: selectedTab == index ? buttonSelected : buttonUnselected)
                    .foregroundStyle(selectedTab == index ? .yellow : .gray)
                
                Text(buttonTitle)
                    .foregroundStyle(selectedTab == index ? .yellow : .gray)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

