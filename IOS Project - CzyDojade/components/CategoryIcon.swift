import SwiftUI

struct CategoryIcon: View {
    let category: IncidentCategory
    var size: CGFloat = Theme.Size.categoryIconLarge

    var body: some View {
        Image(systemName: category.systemImage)
            .font(.system(size: size * Theme.Ratio.categoryGlyph, weight: .semibold))
            .foregroundStyle(Theme.Colors.onAccent)
            .frame(width: size, height: size)
            .background(
                category.color,
                in: RoundedRectangle(cornerRadius: size * Theme.Ratio.categoryCorner, style: .continuous)
            )
    }
}

#Preview {
    HStack {
        ForEach(IncidentCategory.allCases) { category in
            CategoryIcon(category: category)
        }
    }
}
