import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("currentLanguage") private var currentLanguage: String = "en"
    @Published var isRTL: Bool = false

    private init() {
        isRTL = currentLanguage == "ar"
    }

    var translations: [String: [String: String]] = [
        "en": [
            "welcomeMsg": "Welcome to \nGIF Library 👋🏼",
            "sayHello": "Nice to See You Again! 🤗❤️",
            "successRegisteraion": "Registration Completed Successfully!",
            "profile": "Profile",
            "name": "Name",
            "nameLimit": "Max 50 chars",
            "email": "Email",
            "enterYourEmail": "Enter your email",
            "enterYourPassword": "Enter your password",
            "password": "Password",
            "confirmPassword": "Confirm Password",
            "confirmPasswordMsg": "Re-enter your password",
            "phone": "Phone Number",
            "enterYourPhone": "Enter Your Phone",
            "logout": "Logout",
            "deleteAccount": "Delete Account",
            "save": "Save",
            "enterNewName": "Enter new name",
            "language": "Arabic",
            "confirmDelete": "Confirm Delete",
            "deleteWarning": "Are Sure You Want To Delete Your Account?",
            "No": "No",
            "Yes": "Yes",
            "Login": "Login",
            "Register": "Register",
        ],
        "ar": [
            "welcomeMsg": "مرحبا بك في \n مكتبة GIF 👋🏼",
            "sayHello": "من الرائع رأيتك مره اخرى! 🤗❤️",
            "successRegisteraion": "تم انشاء حساب جديد بنجاح!",
            "profile": "الملف الشخصي",
            "name": "الاسم",
            "nameLimit": "٥٠ حرف حد اقصى",
            "email": "البريد الإلكتروني",
            "enterYourEmail": "ادخل البريد الالكتروني",
            "enterYourPassword": "ادخل كلمة المرور",
            "password": "كلمة المرور",
            "confirmPassword": "تاكيد كلمة المرور",
            "confirmPasswordMsg": "اعد ادخال كلمة المرور",
            "phone": "رقم الهاتف",
            "enterYourPhone": "ادخل رقم الهاتف",
            "logout": "تسجيل خروج",
            "deleteAccount": "حذف الحساب",
            "save": "حفظ",
            "enterNewName": "أدخل الاسم الجديد",
            "language": "English",
            "confirmDelete": "تاكيد الحذف",
            "deleteWarning": "هل انت متاكد انك تريد حذف حسابك؟",
            "No": "لا",
            "Yes": "نعم",
            "Login": "تسجيل الدخول",
            "Register": "تسجيل الحساب",
        ],
    ]

    func localizedText(_ key: String) -> String {
        return translations[currentLanguage]?[key] ?? key
    }

    func toggleLanguage() {
        withAnimation {
            currentLanguage = currentLanguage == "en" ? "ar" : "en"
            isRTL = currentLanguage == "ar"

            if let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene
            {
                windowScene.windows.forEach { window in
                    window.semanticContentAttribute =
                        isRTL ? .forceRightToLeft : .forceLeftToRight
                }
            }
        }
    }

    func getCurrentLanguage() -> String {
        return currentLanguage
    }
}
