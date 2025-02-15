import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    @Published var isFormValid = false
    @Published var showSuccessNotification = false
    @Published var navigateToLogin = false

    func validateForm() {
        nameError = ValidationService.validateName(name)
        emailError = ValidationService.validateEmail(email)
        phoneError = ValidationService.validatePhone(phone)
        passwordError = ValidationService.validatePassword(password)
        confirmPasswordError = ValidationService.validateConfirmPassword(password, confirmPassword)

        isFormValid = [nameError, emailError, phoneError, passwordError, confirmPasswordError].allSatisfy { $0 == nil }
    }

    func handleRegister() {
        guard isFormValid else { return }

        AuthService.registerUser(name: name, email: email, phone: phone, password: password)

        showSuccessNotification = true
        navigateToLogin = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showSuccessNotification = false
            }
        }
    }
}
