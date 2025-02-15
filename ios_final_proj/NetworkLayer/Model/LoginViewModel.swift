import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var emailError: String?
    @Published var passwordError: String?

    @Published var isFormValid = false
    @Published var navigateToHome = false

    func validateForm() {
        emailError = ValidationService.validateEmail(email)
        passwordError = ValidationService.validatePassword(password)

        isFormValid = [emailError, passwordError].allSatisfy { $0 == nil }
    }

    func handleLogin() {
        let result = AuthService.login(email: email, password: password)

        if result.success {
            UserDefaults.standard.set(result.name, forKey: "name")
            navigateToHome = true
        } else {
            emailError = emailError ?? (result.error == "Email not found" ? result.error : nil)
            passwordError = passwordError ?? (result.error == "Incorrect password" ? result.error : nil)
        }
    }
}
