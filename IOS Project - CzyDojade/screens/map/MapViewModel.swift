import SwiftUI
import MapKit
import Observation

@Observable
final class MapViewModel {

    static let wroclawRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    var selectedID: UUID?
    var formMode: IncidentFormMode?

    let location = LocationManager()

    func startCreate() {
        formMode = .create
    }

    func startEdit(_ incident: Incident) {
        formMode = .edit(incident)
    }
}
