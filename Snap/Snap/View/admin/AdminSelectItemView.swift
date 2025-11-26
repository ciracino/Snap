import SwiftUI

struct AdminSelectItemView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: ItemViewModel
    
    var body: some View {
        VStack {
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
        .navigationTitle("사진 선택")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: AdminRoute.writeItemInfoView) {
                    Image(systemName: "chevron.right")
                }
                .disabled(viewModel.createdItemImage == nil ? true : false)
            }
        }
    }
}
