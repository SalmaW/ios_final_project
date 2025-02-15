import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 70) {
                Text(languageManager.localizedText("welcomeMsg"))
                    .font(.largeTitle)
                    .padding()

                HStack(spacing: 30) {
                    NavigationLink(destination: LoginScreen()) {
                        CustomText(label: languageManager.localizedText("Login"))
                    }
                    NavigationLink(destination: RegisterationScreen()) {
                        CustomText(label: languageManager.localizedText("Register"))
                    }
                }
                .padding(.horizontal)
            }
        }
        .environment(
            \.layoutDirection,
            languageManager.isRTL ? .rightToLeft : .leftToRight)
    }

    struct CustomText: View {
        var label: String

        var body: some View {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.indigo)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(LanguageManager.shared)
}
