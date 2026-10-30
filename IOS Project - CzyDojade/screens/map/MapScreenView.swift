import SwiftUI
import MapKit

struct MapScreenView: View {

    @State private var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .region(MapViewModel.wroclawRegion)
    @State private var showSatellite = false
    @State private var tab: AppTab = .map

    var body: some View {
        Map(position: $position) {
            ForEach(viewModel.incidents) { incident in
                Annotation(incident.location, coordinate: incident.coordinate) {
                    IncidentMarker(isSelected: viewModel.selectedID == incident.id) {
                        viewModel.selectedID = incident.id
                    }
                }
            }
        }
        .mapStyle(showSatellite ? .hybrid : .standard)
        .mapControls { }
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomArea }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.selectedID) { focusOnSelected() }
        .sheet(item: $viewModel.formMode) { mode in
            IncidentFormView(
                mode: mode,
                onSave: { viewModel.save($0) },
                onDelete: { viewModel.delete($0) }
            )
        }
    }

    private var bottomArea: some View {
        VStack(alignment: .trailing, spacing: 14) {
            MapControlButtons(
                onLocate: { withAnimation { position = .region(MapViewModel.wroclawRegion) } },
                onToggleLayers: { showSatellite.toggle() }
            )
            .padding(.trailing, 16)

            IncidentCarousel(
                incidents: viewModel.incidents,
                selectedID: $viewModel.selectedID,
                onEdit: { viewModel.startEdit($0) }
            )

            AppTabBar(selection: $tab, onAdd: { viewModel.startCreate() })
                .padding(.top, 34)
        }
    }

    private func focusOnSelected() {
        guard let incident = viewModel.selectedIncident else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            position = .region(
                MKCoordinateRegion(
                    center: incident.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
        }
    }
}

#Preview {
    NavigationStack { MapScreenView() }
}
