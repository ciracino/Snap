import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ItemViewModel

    var body: some View {
        Header()
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.items) { item in
                    ItemCard(item: item)
                }
            }
        }
    }
}
