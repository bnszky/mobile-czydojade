import SwiftUI

struct IncidentCarousel: View {

    let incidents: [Incident]
    @Binding var selectedID: Incident.ID?
    let onEdit: (Incident) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(incidents) { incident in
                    IncidentCardView(incident: incident) {
                        onEdit(incident)
                    }
                    .containerRelativeFrame(.horizontal) { length, _ in length - 40 }
                    .id(incident.id)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, 20, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $selectedID)
        .scrollIndicators(.hidden)
        .frame(height: 300)
    }
}
