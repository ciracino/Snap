import SwiftUI

struct ItemCard: View {
    // swift 는 id 를 기반으로 뷰를 추적. 따라서 let 으로 선언하더라도 id 값이 변하지 않는다면 실시간 업데이트 가능!
    let item: Item
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: item.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
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
                    
                    // 아이템의 수량 표시
                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .foregroundStyle(item.quantity > 0 ? .primary : .secondary)
                }
                
                HStack {
                    Image(systemName: "person.3")
                        .foregroundStyle(.secondary)
                    
                    Text("\(item.requests.count)")
                        .font(.subheadline)
                        .foregroundStyle(item.quantity > 0 ? .primary : .secondary)
                }
            }
            Spacer()
            
            if viewModel.isAdmin {
                NavigationLink(value: AdminRoute.itemDetailView(item.id)) {
                    Image(systemName: "chevron.right")
                }
            } else {
                NavigationLink(value: StudentRoute.itemDetailView(item.id)) {
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
