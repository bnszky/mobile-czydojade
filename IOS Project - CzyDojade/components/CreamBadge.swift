import SwiftUI

struct CreamBadge: View {
    let icon: String
    let text: String
    var tint: Color? = nil

    var body: some View {
        HStack(spacing: Theme.Spacing.badge) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: Theme.FontSize.badge, weight: .medium))
        .foregroundStyle(tint == nil ? Color.black.opacity(0.85) : Color.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(tint ?? Color.cream, in: Capsule())
        .overlay(
            Capsule().stroke(tint == nil ? Color.black.opacity(0.7) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        CreamBadge(icon: "tram.fill", text: "Linia 23")
        CreamBadge(icon: "nosign", text: "Blokada", tint: .orange)
    }
    .padding()
}
