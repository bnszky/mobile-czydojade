import SwiftUI

struct MapControlButtons: View {

    let onLocate: () -> Void
    let onToggleLayers: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.mapControls) {
            circleButton(systemName: "location.fill", action: onLocate)
            circleButton(systemName: "square.2.layers.3d", action: onToggleLayers)
        }
    }

    private func circleButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: Theme.FontSize.mapControlIcon, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: Theme.Size.mapControl, height: Theme.Size.mapControl)
                .background(.white, in: Circle())
                .shadow(
                    color: .black.opacity(Theme.Shadow.lightOpacity),
                    radius: Theme.Shadow.lightRadius,
                    x: 0,
                    y: Theme.Shadow.y
                )
        }
    }
}
