import Foundation

class AuthService {
    static func registerUser(name: String, email: String, phone: String, password: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(phone, forKey: "phone")
    }
    
    static func login(email: String, password: String) -> (success: Bool, name: String?, error: String?) {
            let savedEmail = UserDefaults.standard.string(forKey: "email") ?? ""
            let savedPassword = UserDefaults.standard.string(forKey: "password") ?? ""
            let savedName = UserDefaults.standard.string(forKey: "name") ?? ""

            if email == savedEmail && password == savedPassword {
                return (true, savedName, nil)
            } else {
                let error = email != savedEmail ? "Email not found" : "Incorrect password"
                return (false, nil, error)
            }
        }
}
