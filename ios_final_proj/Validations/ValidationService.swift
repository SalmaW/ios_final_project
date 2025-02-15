
import Foundation

struct ValidationService {
    static func validateName(_ name: String) -> String? {
        guard !name.isEmpty else { return "Name is required." }
        guard name.count <= 50 else { return "Name must not exceed 50 characters." }
        return nil
    }
    
    static func validateEmail(_ email: String) -> String? {
        guard !email.isEmpty else { return "Email is required." }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email) ? nil : "Invalid email format."
    }
    
    static func validatePhone(_ phone: String) -> String? {
        guard !phone.isEmpty else { return "Phone number is required." }
        let regex = "^(010|011|012|015)[0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phone) ? nil : "Invalid Egyptian phone number."
    }
    
    static func validatePassword(_ password: String) -> String? {
        guard !password.isEmpty else { return "Password is required." }
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password) ? nil : "Password must contain uppercase, lowercase, digit, and special character."
    }
    
    static func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> String? {
        return password == confirmPassword ? nil : "Passwords do not match."
    }
}

