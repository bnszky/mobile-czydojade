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

    var formMode: IncidentFormMode?

    var selectedIncident: Incident? {
        incidents.first { $0.id == selectedID }
    }

    init(incidents: [Incident] = MapViewModel.sample) {
        self.incidents = incidents
        self.selectedID = incidents.first?.id
    }

    func startCreate() {
        formMode = .create
    }

    func startEdit(_ incident: Incident) {
        formMode = .edit(incident)
    }

    func save(_ incident: Incident) {
        if let index = incidents.firstIndex(where: { $0.id == incident.id }) {
            incidents[index] = incident
        } else {
            incidents.insert(incident, at: 0)
        }
        selectedID = incident.id
    }

    func delete(_ incident: Incident) {
        incidents.removeAll { $0.id == incident.id }
        if selectedID == incident.id {
            selectedID = incidents.first?.id
        }
    }
    
    private static func today(_ hour: Int, _ minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
    }

    static let sample: [Incident] = {
        let placeholder = URL(string: "https://visitwroclaw.eu/wp-content/uploads/2025/07/Wroclaw-z-tramwajem-1.png")
        return [
            Incident(
                line: "Linia 23 (3312)",
                location: "Centrum, Plac Grunwaldzki 24",
                description: "Tramwaj się wykoleił",
                date: today(17, 12),
                isRecent: true,
                imageURL: placeholder,
                latitude: 51.1100, longitude: 17.0620
            ),
            Incident(
                line: "Linia 20 (1254)",
                location: "Centrum, Legnicka 24",
                description: "Magnolia cała zablokowana, w dwóch kierunkach blok",
                date: today(12, 14),
                imageURL: placeholder,
                latitude: 51.1180, longitude: 17.0170
            ),
            Incident(
                line: "Linia 23 (3312)",
                location: "Krzyki, Ołtaszyńska 24",
                description: "Autobus się pali, straż jest ale nie gasi",
                date: today(18, 54),
                isRecent: true,
                imageURL: placeholder,
                latitude: 51.0780, longitude: 17.0300
            )
        ]
    }()
}
