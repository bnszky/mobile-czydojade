import SwiftUI

struct IncidentPhoto: View {

    let imageData: Data?
    let imageURL: URL?

    var body: some View {
        Color.gray.opacity(Theme.Opacity.imagePlaceholder)
            .overlay { content }
            .clipped()
    }

    @ViewBuilder
    private var content: some View {
        if let uiImage = imageData.flatMap(UIImage.init(data:)) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderIcon
                default:
                    ProgressView()
                }
            }
        } else {
            placeholderIcon
        }
    }

    private var placeholderIcon: some View {
        Image(systemName: "photo")
            .font(.largeTitle)
            .foregroundStyle(.secondary)
    }
}

extension IncidentPhoto {
    init(incident: Incident) {
        self.init(imageData: incident.imageData, imageURL: incident.imageURL)
    }
}

#Preview {
    IncidentPhoto(incident: Incident.makeSamples()[0])
        .frame(height: Theme.Size.cardImageHeight)
}
