import SwiftUI

struct CreamBadge: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Theme.Spacing.badge) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: Theme.FontSize.badge, weight: .medium))
        .foregroundStyle(.black.opacity(0.85))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.cream, in: Capsule())
        .overlay(Capsule().stroke(.black.opacity(0.7), lineWidth: 1))
    }
}

#Preview {
    CreamBadge(icon: "tram.fill", text: "Linia 23")
        .padding()
}
