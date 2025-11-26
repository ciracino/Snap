import SwiftUI

struct AdminRequestView: View {
    @EnvironmentObject var viewModel: RentalRequestViewModel
    @EnvironmentObject var itemViewModel: ItemViewModel
    
    // 학생이 요청한 대여 현황이 보여짐
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.rentalRequests) { requests in
                    HStack(spacing: 16) {
                        if let item = itemViewModel.items.first(where: { $0.id == requests.itemId} ) {
                            AsyncImage(url: URL(string: item.imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .failure(let error):
                                    Image(systemName: "xmark")
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(item.name)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                HStack {
                                    Image(systemName: "cube.box")
                                        .foregroundStyle(.secondary)
                                    
                                    Text("1")
                                        .font(.subheadline)
                                        
                                }
                                
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                    
                                    Text("\(viewModel.returnRentalStatus(statusCode: requests.rentalStatus))")
                                        .font(.subheadline)
                                        
                                }
                            }
                            
                            Spacer()
                            
                            NavigationLink(value: AdminRoute.requestDetailView(requests.id)) {
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                }
            }
        }
        .padding()
        .navigationTitle("대여 요청 현황")
        .navigationBarTitleDisplayMode(.inline)
    }
}
