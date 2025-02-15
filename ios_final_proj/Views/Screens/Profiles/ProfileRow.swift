import SwiftUI

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.indigo)
                    .frame(width: 20)
                Text(value)
                    .foregroundColor(isDisabled ? .gray : .black)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview{
    ProfileRow(
        icon: "envelope.fill",
        label: "email",
        value: "userEmail",
        isDisabled: true
    )
}
