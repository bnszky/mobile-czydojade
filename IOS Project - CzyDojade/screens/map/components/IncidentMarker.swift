import SwiftUI

struct IncidentMarker: View {

    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(8)
            .background(isSelected ? Color.red : Color.orange, in: Circle())
            .scaleEffect(isSelected ? 1.2 : 1)
            .shadow(radius: 3)
            .animation(.spring(duration: 0.25), value: isSelected)
            .onTapGesture(perform: onTap)
    }
}
