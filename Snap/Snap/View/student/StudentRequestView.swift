import SwiftUI

struct StudentRequestView: View {
    @EnvironmentObject var viewModel: RentalRequestViewModel
    @EnvironmentObject var itemViewModel: ItemViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // 학생이 요청한 대여 현황이 보여짐
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.rentalRequests.filter { $0.userId == authViewModel.currentUserUID}) { request in
                    HStack(spacing: 16) {
                        if let item = itemViewModel.items.first(where: { $0.id == request.itemId} ) {
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
                                    
                                    Text("\(viewModel.returnRentalStatus(statusCode: request.rentalStatus))")
                                        .font(.subheadline)
                                        
                                }
                            }
                            
                            Spacer()
                            
                            switch request.rentalStatus {
                            case 0:
                                Button {
                                    print("예약 취소")
                                } label: {
                                    Text("취소")
                                        .foregroundStyle(.red)
                                }
                            case 1:
                                Button {
                                    print("반납하기")
                                } label: {
                                    Text("반납")
                                        .foregroundStyle(.blue)
                                }
                            default:
                                EmptyView()
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
