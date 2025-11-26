import SwiftUI

struct AdminWriteItemInfoView: View {
    @EnvironmentObject var viewModel: ItemViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if let image = viewModel.createdItemImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
            }
            
            TextField("name", text: $viewModel.createdItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.none)
            TextField("quantity", text: $viewModel.createdItemQuantity)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            Spacer()
            Button {
                viewModel.createItem()
                path.removeLast()
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .navigationTitle("정보 입력")
    }
}

