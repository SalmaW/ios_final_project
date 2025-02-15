import SwiftUI

struct ActionButtons: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @Binding var navigateToLogin: Bool
    @Binding var showDeleteAlert: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { navigateToLogin = true }) {
                HStack {
                    Image(
                        systemName: "rectangle.portrait.and.arrow.right"
                    )
                    Text(languageManager.localizedText("logout"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button(action: { showDeleteAlert = true }) {  
                HStack {
                    Image(systemName: "trash")
                    Text(languageManager.localizedText("deleteAccount"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(10)
            }
        }
    }
}
