import SwiftUI
import MapKit
import SwiftData

struct MapScreenView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \Incident.date, order: .reverse) private var incidents: [Incident]
    @AppStorage("didSeedIncidents") private var didSeed = false

    @State private var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .region(MapViewModel.wroclawRegion)
    @State private var showSatellite = false
    @State private var tab: AppTab = .map

    private var selectedIncident: Incident? {
        incidents.first { $0.id == viewModel.selectedID }
    }

    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            ForEach(incidents) { incident in
                Annotation(incident.location, coordinate: incident.coordinate) {
                    IncidentMarker(
                        category: incident.category,
                        isSelected: viewModel.selectedID == incident.id
                    ) {
                        viewModel.selectedID = incident.id
                    }
                }
            }
        }
        .mapStyle(showSatellite ? .hybrid : .standard)
        .mapControls { }
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomArea }
        .navigationBarBackButtonHidden(true)
        .task {
            seedIfNeeded()
            viewModel.location.start()
        }
        .onChange(of: incidents.map(\.id), initial: true) { _, ids in
            keepSelectionValid(ids)
        }
        .onChange(of: viewModel.selectedID) { old, _ in
            if old != nil { focusOnSelected() }
        }
        .sheet(item: $viewModel.formMode) { mode in
            IncidentFormView(
                mode: mode,
                userCoordinate: viewModel.location.coordinate,
                onSave: { viewModel.selectedID = $0.id }
            )
        }
    }

    private var bottomArea: some View {
        VStack(alignment: .trailing, spacing: Theme.Spacing.mapBottomStack) {
            MapControlButtons(
                onLocate: { locateUser() },
                onToggleLayers: { showSatellite.toggle() }
            )
            .padding(.trailing, Theme.Spacing.mapControlsTrailing)

            IncidentCarousel(
                incidents: incidents,
                selectedID: $viewModel.selectedID,
                onEdit: { viewModel.startEdit($0) }
            )

            AppTabBar(selection: $tab, onAdd: { viewModel.startCreate() })
                .padding(.top, Theme.Spacing.tabBarTop)
        }
    }

    private func seedIfNeeded() {
        guard !didSeed else { return }
        didSeed = true
        let count = (try? context.fetchCount(FetchDescriptor<Incident>())) ?? 0
        guard count == 0 else { return }
        for incident in Incident.makeSamples() {
            context.insert(incident)
        }
    }

    private func keepSelectionValid(_ ids: [UUID]) {
        if let current = viewModel.selectedID, ids.contains(current) { return }
        viewModel.selectedID = ids.first
    }

    private func locateUser() {
        guard let coordinate = viewModel.location.coordinate else {
            viewModel.location.start()
            return
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            position = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }

    private func focusOnSelected() {
        guard let incident = selectedIncident else { return }
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
        .modelContainer(for: Incident.self, inMemory: true)
}
