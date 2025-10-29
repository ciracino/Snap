import SwiftUI

struct HomeViewBody: View {
    @EnvironmentObject var viewModel: ItemViewModel
    
    let colunms = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    // fetch 위치 : 뷰 init 시점 x, 뷰모델 init 시점 o
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colunms, spacing: 10) {
                ForEach(viewModel.items) { item in
                    AsyncImage(url: URL(string: item.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            NavigationLink {
                                ItemDetailView(item: item, image: image)
                            } label: {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                        case .failure(let error):
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
