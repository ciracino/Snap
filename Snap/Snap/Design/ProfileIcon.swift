import SwiftUI

struct ProfileIcon: View {
    @State var showImagePickerView = false
    @Binding var image: UIImage?
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showImagePickerView.toggle()
            }
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(image == nil ? Color.gray.opacity(0.2) : Color.blue.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(.blue, lineWidth: 2)
                        )
                        .shadow(radius: 4, x: 0, y: 2)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .scaleEffect(showImagePickerView ? 0.95 : 1.0) // 클릭 시 애니메이션
        .sheet(isPresented: $showImagePickerView) {
            ImagePickerView(selectedImage: $image)
        }
    }
}
