import SwiftUI

enum Theme {
    enum Colors {
        static let accent = Color.blue
        static let onAccent = Color.white
        static let surface = Color.white
        static let accentSoft = Color.blue.opacity(0.12)
        static let badgeText = Color.black.opacity(0.85)
        static let screenBackground = Color(.systemGroupedBackground)
    }

    enum Size {
        static let mapControl: CGFloat = 50
        static let tabAdd: CGFloat = 60
        static let cardEdit: CGFloat = 32
        static let cardImageHeight: CGFloat = 200
        static let formImagePreviewHeight: CGFloat = 200
        static let markerIcon: CGFloat = 14
        static let markerPadding: CGFloat = 8
        static let categoryIconSmall: CGFloat = 22
        static let categoryIconLarge: CGFloat = 30
        static let toolbarButton: CGFloat = 44
    }

    enum Ratio {
        static let categoryGlyph: CGFloat = 0.55
        static let categoryCorner: CGFloat = 0.25
    }

    enum FontSize {
        static let mapControlIcon: CGFloat = 18
        static let tabIcon: CGFloat = 22
        static let tabAddIcon: CGFloat = 26
        static let tabLabel: CGFloat = 11
        static let cardTitle: CGFloat = 17
        static let cardBody: CGFloat = 14
        static let cardEditIcon: CGFloat = 14
        static let badge: CGFloat = 12
        static let toolbarIcon: CGFloat = 18
    }

    enum Spacing {
        static let mapControls: CGFloat = 14
        static let mapBottomStack: CGFloat = 14
        static let mapControlsTrailing: CGFloat = 16
        static let tabBarTop: CGFloat = 34
        static let carousel: CGFloat = 12
        static let cardOverlay: CGFloat = 12
        static let cardContent: CGFloat = 14
        static let cardText: CGFloat = 6
        static let badge: CGFloat = 6
        static let badgeHorizontal: CGFloat = 10
        static let badgeVertical: CGFloat = 5
        static let tabItem: CGFloat = 4
        static let tabBarHorizontal: CGFloat = 12
        static let tabBarVertical: CGFloat = 10
        static let tabBarOuter: CGFloat = 20
        static let screenHorizontal: CGFloat = 16
        static let rowContent: CGFloat = 12
        static let rowText: CGFloat = 4
        static let rowMeta: CGFloat = 8
    }

    enum Insets {
        static let formMedia = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    }

    enum Opacity {
        static let imagePlaceholder: Double = 0.2
    }

    enum Radius {
        static let card: CGFloat = 28
        static let formMedia: CGFloat = 12
        static let lineBadge: CGFloat = 6
    }

    enum Shadow {
        static let lightOpacity: Double = 0.2
        static let cardOpacity: Double = 0.18
        static let lightRadius: CGFloat = 5
        static let cardRadius: CGFloat = 8
        static let y: CGFloat = 3
        static let cardY: CGFloat = 4
    }
}
