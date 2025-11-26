import SwiftUI

struct AdminUserListView: View {
    @EnvironmentObject var viewModel: UserListViewModel
    let repo = FirebaseRepository.shared
    
    var body: some View {
        Header()
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.users) { user in
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: user.imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .clipShape(Circle())
                            case .failure(let error):
                                Image(systemName: "xmark")
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(user.name)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                            HStack {
                                Image(systemName: "cube.box")
                                    .foregroundStyle(.secondary)
                                
                                Text("test")
                                    .font(.subheadline)
                                    
                            }
                            
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.secondary)
                                
                                Text("\(user.overdueCount)")
                                    .font(.subheadline)
                                    
                            }
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                        
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                }
            }
        }
    }
}

