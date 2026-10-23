import SwiftUI
import MapKit
import Observation

@Observable
final class MapViewModel {

    static let wroclawRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    var incidents: [Incident]
    var selectedID: Incident.ID?

    var selectedIncident: Incident? {
        incidents.first { $0.id == selectedID }
    }

    init(incidents: [Incident] = MapViewModel.sample) {
        self.incidents = incidents
        self.selectedID = incidents.first?.id
    }

    static let sample: [Incident] = {
        let placeholder = URL(string: "https://visitwroclaw.eu/wp-content/uploads/2025/07/Wroclaw-z-tramwajem-1.png")
        return [
            Incident(
                line: "Linia 23 (3312)",
                location: "Centrum, Plac Grunwaldzki 24",
                description: "Tramwaj się wykoleił",
                time: "17:12",
                isRecent: true,
                imageURL: placeholder,
                latitude: 51.1100, longitude: 17.0620
            ),
            Incident(
                line: "Linia 20 (1254)",
                location: "Centrum, Legnicka 24",
                description: "Magnolia cała zablokowana, w dwóch kierunkach blok",
                time: "12:14",
                imageURL: placeholder,
                latitude: 51.1180, longitude: 17.0170
            ),
            Incident(
                line: "Linia 23 (3312)",
                location: "Krzyki, Ołtaszyńska 24",
                description: "Autobus się pali, straż jest ale nie gasi",
                time: "18:54",
                isRecent: true,
                imageURL: placeholder,
                latitude: 51.0780, longitude: 17.0300
            )
        ]
    }()
}
