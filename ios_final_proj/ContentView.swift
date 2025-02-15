import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isLoggedIn: Bool? = nil

    var body: some View {
        Group {
            if let isLoggedIn = isLoggedIn {
                if isLoggedIn {
                    HomeScreen()
                } else {
                    WelcomeScreen()
                }
            } else {
                ProgressView()
                    .onAppear {
                        checkLoginStatus()
                    }
            }
        }
        .environmentObject(languageManager)
    }

    private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}
