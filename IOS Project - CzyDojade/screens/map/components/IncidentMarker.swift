import SwiftUI

struct IncidentMarker: View {

    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: Theme.Size.markerIcon))
            .foregroundStyle(.white)
            .padding(Theme.Size.markerPadding)
            .background(isSelected ? Color.red : Color.orange, in: Circle())
            .scaleEffect(isSelected ? 1.2 : 1)
            .shadow(radius: 3)
            .animation(.spring(duration: 0.25), value: isSelected)
            .onTapGesture(perform: onTap)
    }
}
