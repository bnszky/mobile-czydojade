import SwiftUI

struct IncidentCard: View {

    let incident: Incident

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageHeader
            detailsSection
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
        .shadow(
            color: .black.opacity(Theme.Shadow.cardOpacity),
            radius: Theme.Shadow.cardRadius,
            x: 0,
            y: Theme.Shadow.cardY
        )
    }

    private var imageHeader: some View {
        IncidentPhoto(incident: incident)
            .frame(height: Theme.Size.cardImageHeight)
            .overlay(alignment: .topTrailing) {
                InfoBadge(icon: "tram.fill", text: incident.vehicleLabel).padding(Theme.Spacing.cardOverlay)
            }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.cardText) {
            Text(incident.location)
                .font(.system(size: Theme.FontSize.cardTitle, weight: .semibold))
                .foregroundStyle(.black)

            Text(incident.details)
                .font(.system(size: Theme.FontSize.cardBody))
                .foregroundStyle(.black.opacity(0.85))
                .lineLimit(2)

            HStack(spacing: 10) {
                Text(incident.timeText)
                    .font(.system(size: Theme.FontSize.cardBody))
                    .foregroundStyle(.black.opacity(0.8))

                InfoBadge(
                    icon: incident.category.systemImage,
                    text: incident.category.title,
                    tint: incident.category.color
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.cardContent)
    }
}

#Preview {
    IncidentCard(incident: Incident.makeSamples()[0])
        .padding()
}
