import SwiftUI

struct IncidentMarker: View {

    let category: IncidentCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Image(systemName: category.systemImage)
            .font(.system(size: Theme.Size.markerIcon))
            .foregroundStyle(.white)
            .padding(Theme.Size.markerPadding)
            .background(category.color, in: Circle())
            .overlay(Circle().stroke(.white, lineWidth: isSelected ? 3 : 0))
            .scaleEffect(isSelected ? 1.2 : 1)
            .shadow(radius: 3)
            .animation(.spring(duration: 0.25), value: isSelected)
            .onTapGesture(perform: onTap)
    }
}
