import Foundation
import CoreLocation
import SwiftData

@Model
final class Incident {
    @Attribute(.unique) var id: UUID
    var category: IncidentCategory
    var line: String
    var vehicleNumber: String
    var location: String
    var details: String
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

    var vehicleLabel: String {
        vehicleNumber.isEmpty ? "Linia \(line)" : "Linia \(line) (\(vehicleNumber))"
    }

    init(
        id: UUID = UUID(),
        category: IncidentCategory = .other,
        line: String,
        vehicleNumber: String = "",
        location: String,
        details: String,
        date: Date = .now,
        imageURL: URL? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.category = category
        self.line = line
        self.vehicleNumber = vehicleNumber
        self.location = location
        self.details = details
        self.date = date
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Incident {
    static func makeSamples() -> [Incident] {
        let placeholder = URL(string: "https://visitwroclaw.eu/wp-content/uploads/2025/07/Wroclaw-z-tramwajem-1.png")

        func today(_ hour: Int, _ minute: Int) -> Date {
            Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
        }

        return [
            Incident(
                category: .breakdown,
                line: "23",
                vehicleNumber: "3312",
                location: "Centrum, Plac Grunwaldzki 24",
                details: "Tramwaj się wykoleił",
                date: today(17, 12),
                imageURL: placeholder,
                latitude: 51.1100, longitude: 17.0620
            ),
            Incident(
                category: .blockage,
                line: "20",
                vehicleNumber: "1254",
                location: "Centrum, Legnicka 24",
                details: "Magnolia cała zablokowana, w dwóch kierunkach blok",
                date: today(12, 14),
                imageURL: placeholder,
                latitude: 51.1180, longitude: 17.0170
            ),
            Incident(
                category: .vehicleCondition,
                line: "23",
                vehicleNumber: "3312",
                location: "Krzyki, Ołtaszyńska 24",
                details: "Autobus się pali, straż jest ale nie gasi",
                date: today(18, 54),
                imageURL: placeholder,
                latitude: 51.0780, longitude: 17.0300
            )
        ]
    }
}
