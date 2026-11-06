import Foundation
import CoreLocation

struct Incident: Identifiable, Hashable {
    let id: UUID
    var category: IncidentCategory
    var line: String
    var location: String
    var description: String
    var date: Date
    var imageURL: URL?
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var timeText: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    init(
        id: UUID = UUID(),
        category: IncidentCategory = .other,
        line: String,
        location: String,
        description: String,
        date: Date = .now,
        imageURL: URL? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.category = category
        self.line = line
        self.location = location
        self.description = description
        self.date = date
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
