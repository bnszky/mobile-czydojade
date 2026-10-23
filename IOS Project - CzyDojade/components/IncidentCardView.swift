import SwiftUI

struct IncidentCardView: View {

    let incident: Incident

    private let cream = Color(red: 0.99, green: 0.90, blue: 0.80)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.gray.opacity(0.2)
                .frame(height: 200)
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
                    badge(icon: "tram.fill", text: incident.line)
                        .padding(12)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(incident.location)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)

                Text(incident.description)
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.85))
                    .lineLimit(2)

                HStack(spacing: 10) {
                    Text(incident.time)
                        .font(.system(size: 14))
                        .foregroundStyle(.black.opacity(0.8))

                    if incident.isRecent {
                        badge(icon: "exclamationmark.circle", text: "Ostatnie")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
    }

    private func badge(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.black.opacity(0.85))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(cream, in: Capsule())
        .overlay(Capsule().stroke(.black.opacity(0.7), lineWidth: 1))
    }
}

#Preview {
    IncidentCardView(incident: MapViewModel.sample[0])
        .padding()
}
