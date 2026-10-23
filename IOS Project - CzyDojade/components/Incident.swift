import Foundation
import CoreLocation

struct Incident: Identifiable, Hashable {
    let id: UUID
    var line: String
    var location: String
    var description: String
    var time: String
    var isRecent: Bool
    var imageURL: URL?
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(
        id: UUID = UUID(),
        line: String,
        location: String,
        description: String,
        time: String,
        isRecent: Bool = false,
        imageURL: URL? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.line = line
        self.location = location
        self.description = description
        self.time = time
        self.isRecent = isRecent
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
