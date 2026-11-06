import SwiftUI
import MapKit
import Observation
import SwiftData

enum IncidentFormMode: Identifiable {
    case create
    case edit(Incident)

    var id: String {
        switch self {
        case .create: return "create"
        case .edit(let incident): return String(describing: incident.persistentModelID)
        }
    }
}

@Observable
final class IncidentFormViewModel {

    let mode: IncidentFormMode
    private let existing: Incident?
    private let resolvesAddressOnAppear: Bool

    @ObservationIgnored private var geocodeTask: Task<Void, Never>?

    var category: IncidentCategory
    var line: String
    var vehicleNumber: String
    var location: String
    var details: String
    var date: Date
    var imageURLText: String
    var coordinate: CLLocationCoordinate2D

    init(mode: IncidentFormMode, userCoordinate: CLLocationCoordinate2D? = nil) {
        self.mode = mode
        switch mode {
        case .create:
            existing = nil
            resolvesAddressOnAppear = userCoordinate != nil
            category = .other
            line = ""
            vehicleNumber = ""
            location = ""
            details = ""
            date = .now
            imageURLText = ""
            coordinate = userCoordinate ?? MapViewModel.wroclawRegion.center
        case .edit(let incident):
            existing = incident
            resolvesAddressOnAppear = false
            category = incident.category
            line = incident.line
            vehicleNumber = incident.vehicleNumber
            location = incident.location
            details = incident.details
            date = incident.date
            imageURLText = incident.imageURL?.absoluteString ?? ""
            coordinate = incident.coordinate
        }
    }

    var isEditing: Bool { existing != nil }

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

    // MARK: - Adres z mapy

    func resolveInitialAddress() {
        if resolvesAddressOnAppear { resolveAddress() }
    }

    func setCoordinate(_ newValue: CLLocationCoordinate2D) {
        coordinate = newValue
        resolveAddress()
    }

    private func resolveAddress() {
        geocodeTask?.cancel()
        let point = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocodeTask = Task { @MainActor [self] in
            let placemarks = (try? await CLGeocoder().reverseGeocodeLocation(point)) ?? []
            guard !Task.isCancelled,
                  let placemark = placemarks.first,
                  let address = Self.format(placemark) else { return }
            location = address
        }
    }

    private static func format(_ placemark: CLPlacemark) -> String? {
        let street = [placemark.thoroughfare, placemark.subThoroughfare]
            .compactMap { $0 }
            .joined(separator: " ")
        let parts = [placemark.subLocality ?? placemark.locality,
                     street.isEmpty ? nil : street]
            .compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }

    // MARK: - SwiftData

    @discardableResult
    func save(in context: ModelContext) -> Incident {
        let text = trimmed(imageURLText)
        let url = text.isEmpty ? nil : URL(string: text)

        let incident: Incident
        if let existing {
            incident = existing
            incident.category = category
            incident.line = trimmed(line)
            incident.vehicleNumber = trimmed(vehicleNumber)
            incident.location = trimmed(location)
            incident.details = trimmed(details)
            incident.date = date
            incident.imageURL = url
            incident.latitude = coordinate.latitude
            incident.longitude = coordinate.longitude
        } else {
            incident = Incident(
                category: category,
                line: trimmed(line),
                vehicleNumber: trimmed(vehicleNumber),
                location: trimmed(location),
                details: trimmed(details),
                date: date,
                imageURL: url,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            context.insert(incident)
        }
        try? context.save()
        return incident
    }

    func delete(in context: ModelContext) {
        guard let existing else { return }
        context.delete(existing)
        try? context.save()
    }

    private func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
