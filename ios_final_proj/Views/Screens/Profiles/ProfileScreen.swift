import SwiftUI

struct ProfileScreen: View {
    private func getOppositeLanguage() -> String {
        return languageManager.isRTL ? "English" : "العربية"
    }

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var languageManager: LanguageManager

    @State private var isEditingName = false
    @State private var updateName: String = ""

    @AppStorage("name") private var userName: String = "User Name"
    @AppStorage("email") private var userEmail: String = "user.name@example.com"
    @AppStorage("phone") private var userPhoneNumber: String = "123-456-7890"

    @State private var navigateToLogin = false
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.indigo)
                        .background(
                            Circle()
                                .fill(Color.indigo.opacity(0.1))
                                .frame(width: 90, height: 90)
                        )
                        .padding(.top, 8)

                    Menu {
                        Button(action: { languageManager.toggleLanguage() }) {
                            HStack {
                                Text(getOppositeLanguage())
                                Image(systemName: "checkmark")
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "globe")
                                .foregroundColor(.indigo)
                            Text(languageManager.localizedText("language"))
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption)
                                .foregroundColor(.indigo)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.indigo.opacity(0.1))
                        )
                    }
                }

                ProfileInfoScetion(
                    isEditingName: $isEditingName,
                    updateName: $updateName,
                    userName: userName,
                    userEmail: userEmail,
                    userPhoneNumber: userPhoneNumber
                )
                .environmentObject(LanguageManager.shared)

                Spacer()

                ActionButtons(
                    navigateToLogin: $navigateToLogin,
                    showDeleteAlert: $showDeleteAlert
                )
                .environmentObject(LanguageManager.shared)

                NavigationLink(
                    destination: WelcomeScreen(), isActive: $navigateToLogin
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle(languageManager.localizedText("profile"))
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text(
                        languageManager.localizedText(
                            languageManager.localizedText("confirmDelete"))),
                    message: Text(
                        languageManager.localizedText("deleteWarning")),
                    primaryButton: .destructive(
                        Text(languageManager.localizedText("Yes"))
                    ) {
                        deleteAccount()
                    },
                    secondaryButton: .cancel(
                        Text(languageManager.localizedText("No"))
                    ) {}
                )
            }
        }
        .environment(
            \.layoutDirection,
            languageManager.isRTL ? .rightToLeft : .leftToRight)
    }

    private func deleteAccount() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "password")
        navigateToLogin = true
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first
        {
            window.rootViewController = UIHostingController(
                rootView: WelcomeScreen().environmentObject(languageManager))
            window.makeKeyAndVisible()
        }
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(LanguageManager.shared)
}
