import SwiftUI

struct ProfileInfoScetion: View {
    @EnvironmentObject private var languageManager: LanguageManager
    
    @Binding var isEditingName: Bool
    @Binding var updateName: String
    
    var userName: String
    var userEmail: String
    var userPhoneNumber: String
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(languageManager.localizedText("name"))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if isEditingName {
                    HStack {
                        TextField(
                            languageManager.localizedText("enterupdateName"),
                            text: $updateName
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.5))
                                .allowsHitTesting(false))

                        Button(action: saveName) {
                            Text(languageManager.localizedText("save"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                } else {
                    HStack {
                        Text(userName)
                        Spacer()
                        Image(systemName: "pencil")
                            .foregroundColor(.indigo)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(
                        color: Color.black.opacity(0.05), radius: 2,
                        x: 0, y: 1
                    )
                    .onTapGesture {
                        isEditingName = true
                        updateName = userName
                    }
                }
            }

            ProfileRow(
                icon: "envelope.fill",
                label: languageManager.localizedText("email"),
                value: userEmail,
                isDisabled: true
            )

            ProfileRow(
                icon: "phone.fill",
                label: languageManager.localizedText("phone"),
                value: userPhoneNumber,
                isDisabled: true
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func saveName() {
        UserDefaults.standard.set(updateName, forKey: "name")
        isEditingName = false
    }
}
