import SwiftUI

struct IncidentCardView: View {

    let incident: Incident
    var onEdit: (() -> Void)? = nil

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
        Color.gray.opacity(0.2)
            .frame(height: Theme.Size.cardImageHeight)
            .overlay {
                AsyncImage(url: incident.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
            }
            .clipped()
            .overlay(alignment: .topTrailing) {
                CreamBadge(icon: "tram.fill", text: incident.line)
                    .padding(Theme.Spacing.cardOverlay)
            }
            .overlay(alignment: .topLeading) {
                if let onEdit {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: Theme.FontSize.cardEditIcon, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: Theme.Size.cardEdit, height: Theme.Size.cardEdit)
                            .background(Color.cream, in: Circle())
                            .overlay(Circle().stroke(.black.opacity(0.7), lineWidth: 1))
                    }
                    .padding(Theme.Spacing.cardOverlay)
                }
            }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.cardText) {
            Text(incident.location)
                .font(.system(size: Theme.FontSize.cardTitle, weight: .semibold))
                .foregroundStyle(.black)

            Text(incident.description)
                .font(.system(size: Theme.FontSize.cardBody))
                .foregroundStyle(.black.opacity(0.85))
                .lineLimit(2)

            HStack(spacing: 10) {
                Text(incident.timeText)
                    .font(.system(size: Theme.FontSize.cardBody))
                    .foregroundStyle(.black.opacity(0.8))

                if incident.isRecent {
                    CreamBadge(icon: "exclamationmark.circle", text: "Ostatnie")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.cardContent)
    }
}

#Preview {
    IncidentCardView(incident: MapViewModel.sample[0], onEdit: {})
        .padding()
}
