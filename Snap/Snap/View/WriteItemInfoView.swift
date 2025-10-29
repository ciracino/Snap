import SwiftUI

struct WriteItemInfoView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
            }
            
            if let image = viewModel.createdItemImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
            }
            
            TextField("name", text: $viewModel.createdItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.none)
            TextField("price", text: $viewModel.createdItemQuantity)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            Spacer()
            Button {
                viewModel.createItem()
                path.removeLast(2)
            } label: {
                Text("확인")
            }
            .buttonStyle(CustomButton())
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView("아이템 정보 저장 중...")
                    .padding()
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
