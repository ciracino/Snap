import SwiftUI

struct SelectItemView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                if let image = viewModel.createdItemImage {
                    Button {
                        path.append(Destination.writeItemInfoView)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                } else {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(viewModel.createdItemImage == nil)
                }
            }
            .padding()
            if let image = viewModel.createdItemImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 250)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Text("이미지를 선택하세요")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .frame(height: 100)
                    .padding()
            }
            Spacer()
            PhotoPicker(selectedImage: $viewModel.createdItemImage)
                .frame(maxWidth: .infinity, maxHeight: 500)
        }
        .navigationBarBackButtonHidden(true)
    }
}
