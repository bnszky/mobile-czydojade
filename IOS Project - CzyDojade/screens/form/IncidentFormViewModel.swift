import SwiftUI
import MapKit
import Observation
import PhotosUI
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
    @ObservationIgnored private var photoLoadTask: Task<Void, Never>?

    var category: IncidentCategory
    var line: String
    var vehicleNumber: String
    var location: String
    var details: String
    var date: Date
    var coordinate: CLLocationCoordinate2D

    var photoSelection: PhotosPickerItem?
    private(set) var imageData: Data?
    private(set) var imageURL: URL?
    private(set) var isLoadingPhoto = false
    private(set) var photoLoadFailed = false

    init(mode: IncidentFormMode, userCoordinate: CLLocationCoordinate2D? = nil) {
        self.mode = mode
        switch mode {
        case .create:
            existing = nil
            resolvesAddressOnAppear = userCoordinate != nil
            category = .defaultCategory
            line = ""
            vehicleNumber = ""
            location = ""
            details = ""
            date = .now
            imageData = nil
            imageURL = nil
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
            imageData = incident.imageData
            imageURL = incident.imageURL
            coordinate = incident.coordinate
        }
    }

    var isEditing: Bool { existing != nil }

    var title: String {
        isEditing ? "Edytuj zgłoszenie" : "Nowe zgłoszenie"
    }

    var hasImage: Bool { imageData != nil || imageURL != nil }

    var isValid: Bool {
        !trimmed(line).isEmpty
        && !trimmed(location).isEmpty
        && !trimmed(details).isEmpty
        && !isLoadingPhoto
    }

    func loadSelectedPhoto() {
        photoLoadTask?.cancel()
        guard let item = photoSelection else { return }

        isLoadingPhoto = true
        photoLoadFailed = false
        photoLoadTask = Task { @MainActor [self] in
            let rawData = try? await item.loadTransferable(type: Data.self)
            guard !Task.isCancelled else { return }
            isLoadingPhoto = false

            guard let rawData,
                  let compressed = ImageCompressor.compressedJPEG(from: rawData) else {
                photoLoadFailed = true
                return
            }
            imageData = compressed
            imageURL = nil
        }
    }

    func removePhoto() {
        photoLoadTask?.cancel()
        photoSelection = nil
        imageData = nil
        imageURL = nil
        isLoadingPhoto = false
        photoLoadFailed = false
    }

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
        let incident: Incident
        if let existing {
            incident = existing
            incident.category = category
            incident.line = trimmed(line)
            incident.vehicleNumber = trimmed(vehicleNumber)
            incident.location = trimmed(location)
            incident.details = trimmed(details)
            incident.date = date
            incident.imageData = imageData
            incident.imageURL = imageURL
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
                imageData: imageData,
                imageURL: imageURL,
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
