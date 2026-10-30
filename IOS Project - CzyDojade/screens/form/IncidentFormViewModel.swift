import SwiftUI
import MapKit
import Observation

enum IncidentFormMode: Identifiable {
    case create
    case edit(Incident)

    var id: String {
        switch self {
        case .create: return "create"
        case .edit(let incident): return incident.id.uuidString
        }
    }
}

@Observable
final class IncidentFormViewModel {

    let mode: IncidentFormMode
    private let id: UUID

    var line: String
    var location: String
    var details: String
    var date: Date
    var isRecent: Bool
    var imageURLText: String
    var coordinate: CLLocationCoordinate2D

    init(mode: IncidentFormMode) {
        self.mode = mode
        switch mode {
        case .create:
            id = UUID()
            line = ""
            location = ""
            details = ""
            date = .now
            isRecent = true
            imageURLText = ""
            coordinate = MapViewModel.wroclawRegion.center
        case .edit(let incident):
            id = incident.id
            line = incident.line
            location = incident.location
            details = incident.description
            date = incident.date
            isRecent = incident.isRecent
            imageURLText = incident.imageURL?.absoluteString ?? ""
            coordinate = incident.coordinate
        }
    }


    var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    var title: String {
        isEditing ? "Edytuj zgłoszenie" : "Nowe zgłoszenie"
    }

    var isImageURLValid: Bool {
        let text = trimmed(imageURLText)
        guard !text.isEmpty else { return true }
        guard let url = URL(string: text), let scheme = url.scheme else { return false }
        return scheme == "http" || scheme == "https"
    }

    var isValid: Bool {
        !trimmed(line).isEmpty
        && !trimmed(location).isEmpty
        && !trimmed(details).isEmpty
        && isImageURLValid
    }

    func makeIncident() -> Incident {
        let text = trimmed(imageURLText)
        return Incident(
            id: id,
            line: trimmed(line),
            location: trimmed(location),
            description: trimmed(details),
            date: date,
            isRecent: isRecent,
            imageURL: text.isEmpty ? nil : URL(string: text),
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }

    private func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
