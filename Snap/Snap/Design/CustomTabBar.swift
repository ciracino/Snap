import SwiftUI

struct CustomTabBar: View {
    let isAdmin: Bool
    @Binding var selectedTab: Int
    
    var body: some View {
        if isAdmin {
            HStack {
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "house", buttonSelected: "house.fill", buttonTitle: "홈", index: 0)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "list.clipboard", buttonSelected: "list.clipboard.fill", buttonTitle: "대여", index: 1)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "plus.circle", buttonSelected: "plus.circle.fill", buttonTitle: "등록", index: 2)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "person.3", buttonSelected: "person.3.fill", buttonTitle: "유저", index: 3)
            }
            .frame(height: 85)
        } else {
            HStack {
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "house", buttonSelected: "house.fill", buttonTitle: "홈", index: 0)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "list.clipboard", buttonSelected: "list.clipboard.fill", buttonTitle: "대여", index: 1)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "plus.circle", buttonSelected: "plus.circle.fill", buttonTitle: "포스트", index: 2)
                TabBarButton(selectedTab: $selectedTab, buttonUnselected: "person.3", buttonSelected: "person.3.fill", buttonTitle: "커뮤니티", index: 3)
            }
            .frame(height: 85)
        }
    }
}
