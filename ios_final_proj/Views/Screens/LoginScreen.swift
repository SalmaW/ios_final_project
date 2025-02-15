import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ZStack {
                    Image("login")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)

                    Text(languageManager.localizedText("sayHello"))
                        .font(.title2)
                        .padding()
                        .offset(y: -110)
                }

                CustomTextField(
                    title: languageManager.localizedText("email"),
                    placeholder: languageManager.localizedText("enterYourEmail"),
                    text: $viewModel.email,
                    keyboardType: .emailAddress,
                    errorMessage: viewModel.emailError ?? "",
                    onTextChanged: viewModel.validateForm
                )

                CustomTextField(
                    title: languageManager.localizedText("password"),
                    placeholder: languageManager.localizedText("enterYourPassword"),
                    text: $viewModel.password,
                    isSecure: true,
                    errorMessage: viewModel.passwordError ?? "",
                    onTextChanged: viewModel.validateForm
                )

                Button(action: viewModel.handleLogin) {
                    Text(languageManager.localizedText("Login"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? Color.indigo : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .disabled(!viewModel.isFormValid)
                .padding(.horizontal)

                NavigationLink("", destination: HomeScreen().navigationBarBackButtonHidden(true), isActive: $viewModel.navigateToHome)
            }
            .padding()
            .navigationTitle(languageManager.localizedText("Login"))
        }
        .environment(
            \.layoutDirection,
            languageManager.isRTL ? .rightToLeft : .leftToRight)
    }

}

#Preview {
    LoginScreen()
        .environmentObject(LanguageManager.shared)
}
