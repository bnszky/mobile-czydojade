import Foundation
import CoreLocation

struct Incident: Identifiable, Hashable {
    let id: UUID
    var line: String
    var location: String
    var description: String
    var date: Date
    var isRecent: Bool
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
        line: String,
        location: String,
        description: String,
        date: Date = .now,
        isRecent: Bool = false,
        imageURL: URL? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.line = line
        self.location = location
        self.description = description
        self.date = date
        self.isRecent = isRecent
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
