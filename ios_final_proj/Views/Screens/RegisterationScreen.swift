import SwiftUI

struct RegisterationScreen: View {
    @EnvironmentObject private var languageManager: LanguageManager

    @StateObject private var viewModel = RegistrationViewModel()

    @FocusState private var focusedField: Field?
    @State private var showSuccessPopup = false

    enum Field: Hashable {
        case name, email, phone, password, confirmPassword
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 15) {
                        Image("register")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)

                        CustomTextField(
                            title: languageManager.localizedText("name"),
                            placeholder: languageManager.localizedText(
                                "nameLimit"),
                            text: $viewModel.name,
                            errorMessage: viewModel.nameError ?? "",
                            onTextChanged: viewModel.validateForm
                        )
                        .focused($focusedField, equals: .name)

                        CustomTextField(
                            title: languageManager.localizedText("email"),
                            placeholder: languageManager.localizedText(
                                "enterYourEmail"),
                            text: $viewModel.email,
                            keyboardType: .emailAddress,
                            errorMessage: viewModel.emailError ?? "",
                            onTextChanged: viewModel.validateForm
                        )
                        .focused($focusedField, equals: .email)

                        CustomTextField(
                            title: languageManager.localizedText("phone"),
                            placeholder: languageManager.localizedText(
                                "enterYourPhone"),
                            text: $viewModel.phone,
                            keyboardType: .phonePad,
                            errorMessage: viewModel.phoneError ?? "",
                            onTextChanged: viewModel.validateForm
                        )
                        .focused($focusedField, equals: .phone)

                        CustomTextField(
                            title: languageManager.localizedText("password"),
                            placeholder: languageManager.localizedText(
                                "enterYourPassword"),
                            text: $viewModel.password,
                            isSecure: true,
                            errorMessage: viewModel.passwordError ?? "",
                            onTextChanged: viewModel.validateForm
                        )
                        .focused($focusedField, equals: .password)

                        CustomTextField(
                            title: languageManager.localizedText(
                                "confirmPassword"),
                            placeholder: languageManager.localizedText(
                                "confirmPasswordMsg"),
                            text: $viewModel.confirmPassword,
                            isSecure: true,
                            errorMessage: viewModel.confirmPasswordError ?? "",
                            onTextChanged: viewModel.validateForm
                        )
                        .focused($focusedField, equals: .confirmPassword)

                        Button(action: viewModel.handleRegister) {
                            Text(languageManager.localizedText("Register"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    viewModel.isFormValid
                                        ? Color.indigo : Color.gray
                                )
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(!viewModel.isFormValid)
                        .padding(.horizontal)
                    }
                    .padding()
                    .navigationTitle(languageManager.localizedText("Register"))
                }
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {
                    focusedField = nil
                }

                if showSuccessPopup {
                    VStack {
                        Spacer()
                        Text(
                            languageManager.localizedText(
                                "Registration Completed Successfully!")
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .transition(.slide)
                        .animation(.easeInOut, value: showSuccessPopup)
                        Spacer()
                    }
                }
            }
        }
        .environment(
            \.layoutDirection,
            languageManager.isRTL ? .rightToLeft : .leftToRight
        )
        .background(
            NavigationLink(
                "",
                destination: WelcomeScreen().navigationBarBackButtonHidden(
                    true),
                isActive: $viewModel.navigateToLogin
            )
            .hidden()
        )
    }
    private func handleRegister() {
        viewModel.handleRegister()
        if viewModel.showSuccessNotification {
            showSuccessPopup = true

            // Hide success message after 3 seconds and navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSuccessPopup = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.navigateToLogin = true
                }
            }
        }
    }

}

#Preview {
    RegisterationScreen()
        .environmentObject(LanguageManager.shared)
}
