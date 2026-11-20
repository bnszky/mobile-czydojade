import SwiftUI

struct InfoBadge: View {
    let icon: String
    let text: String
    var tint: Color? = nil

    var body: some View {
        HStack(spacing: Theme.Spacing.badge) {
            Image(systemName: icon)
                .foregroundStyle(tint == nil ? Theme.Colors.accent : Theme.Colors.onAccent)
            Text(text)
        }
        .font(.system(size: Theme.FontSize.badge, weight: .medium))
        .foregroundStyle(tint == nil ? Theme.Colors.badgeText : Theme.Colors.onAccent)
        .padding(.horizontal, Theme.Spacing.badgeHorizontal)
        .padding(.vertical, Theme.Spacing.badgeVertical)
        .background(tint ?? Theme.Colors.surface, in: Capsule())
    }
}

#Preview {
    VStack(spacing: Theme.Spacing.carousel) {
        InfoBadge(icon: "tram.fill", text: "Linia 23")
        InfoBadge(icon: "nosign", text: "Blokada", tint: .orange)
    }
    .padding()
    .background(Color.gray)
}
