import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    // Coordinator 클래스 정의
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(parent: PhotoPicker) {
            self.parent = parent
        }

        // Picker에서 선택이 완료되었을 때 호출
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Picker를 dismiss하지 않고 유지
            guard let provider = results.first?.itemProvider else { return }

            // 이미지를 로드할 수 있는지 확인
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }

    // Coordinator 생성
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // PHPickerViewController 생성
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 선택 가능한 이미지 개수 (1로 설정)
        configuration.filter = .images // 이미지 필터링 (사진만 선택 가능)

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    // 뷰 업데이트 (필요 시)
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Picker의 설정을 업데이트할 필요가 없으므로 비워둠
    }
}
