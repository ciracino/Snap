import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var isSignUp: Bool = false
    @State var showAuthViewInfo: Bool = false // 사용방법 안내 시트 활성화 플래그
    
    var body: some View {
        VStack {
            HStack {
                Text(isSignUp ? "회원가입" : "로그인")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Toggle("", isOn: $isSignUp)
            }
            if isSignUp {
                ProfileIcon(image: $viewModel.selectedImage)
            }
            TextField("이메일", text: $viewModel.email)
                .padding()
                .keyboardType(.emailAddress)
            SecureField("패스워드", text: $viewModel.password)
                .padding()
            Button {
                showAuthViewInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .sheet(isPresented: $showAuthViewInfo) {
                VStack {
                    Text("회원가입")
                        .font(.title)
                    Text("관리자와 학생 양쪽 다 원하는 이메일로 회원가입하시면 됩니다.")
                    Text("관리자의 경우, fireStore 의 isAdmin 필드 값을 true 로 수동 변경하여 관리자 권한을 얻을 수 있습니다.")
                    Divider()
                    Text("로그인")
                        .font(.title)
                    Text("관리자와 학생 양쪽 다 이메일로 로그인하시면 됩니다.")
                }
            }
            
            Spacer()
            Button {
                if isSignUp {
                    viewModel.signUp()
                } else {
                    viewModel.signIn()
                }
            } label: {
                Text(isSignUp ? "회원가입" : "로그인")
            }
            .buttonStyle(CustomButton())
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
}

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 0.5)
            )
    }
}
