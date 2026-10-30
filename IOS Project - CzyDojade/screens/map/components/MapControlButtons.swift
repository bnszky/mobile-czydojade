import SwiftUI

struct MapControlButtons: View {

    let onLocate: () -> Void
    let onToggleLayers: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            circleButton(systemName: "location.fill", action: onLocate)
            circleButton(systemName: "square.2.layers.3d", action: onToggleLayers)
        }
    }

    private func circleButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 50, height: 50)
                .background(.white, in: Circle())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
}
