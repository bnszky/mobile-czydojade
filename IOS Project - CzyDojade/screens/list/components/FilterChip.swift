import SwiftUI

struct FilterChip: View {

    let title: String
    let onRemove: () -> Void

    var body: some View {
        Button(action: onRemove) {
            HStack(spacing: Theme.Spacing.rowText) {
                Text(title)
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Theme.Colors.accent)
            .padding(.horizontal, Theme.Spacing.chipHorizontal)
            .padding(.vertical, Theme.Spacing.chipVertical)
            .background(Theme.Colors.accentSoft, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityHint("Usuwa filtr")
    }
}

#Preview {
    FilterChip(title: "Ostatnie 24 h", onRemove: {})
}
