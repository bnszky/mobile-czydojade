import SwiftUI
import CoreLocation

struct IncidentListView: View {

    @Bindable var viewModel: IncidentListViewModel
    let incidents: [Incident]
    let userLocation: CLLocation?
    let onSelect: (Incident) -> Void

    var body: some View {
        let sections = viewModel.sections(from: incidents, userLocation: userLocation)

        VStack(alignment: .leading, spacing: 0) {
            header

            if incidents.isEmpty {
                noIncidentsState
            } else if sections.isEmpty {
                noResultsState
            } else {
                list(sections)
            }
        }
        .background(Theme.Colors.screenBackground)
        .task(id: userLocation) {
            await viewModel.updateLocationName(for: userLocation)
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            IncidentFilterView(filter: viewModel.filter) { viewModel.filter = $0 }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.listHeader) {
            HStack {
                Spacer()
                filterButton
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.rowText) {
                Text("Zgłoszenia")
                    .font(.largeTitle.bold())
                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            SearchField(placeholder: "Adres, linia lub numer pojazdu", text: $viewModel.searchText)

            if !viewModel.activeFilters.isEmpty {
                activeFiltersRow
            }
        }
        .padding(.horizontal, Theme.Spacing.screenHorizontal)
    }

    private var filterButton: some View {
        Button {
            viewModel.isFilterSheetPresented = true
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.system(size: Theme.FontSize.toolbarIcon, weight: .semibold))
                .foregroundStyle(Theme.Colors.accent)
                .frame(width: Theme.Size.toolbarButton, height: Theme.Size.toolbarButton)
                .background(Theme.Colors.surface, in: Circle())
        }
        .accessibilityLabel("Filtry")
    }

    private var activeFiltersRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Theme.Spacing.chips) {
                ForEach(viewModel.activeFilters) { activeFilter in
                    FilterChip(title: viewModel.title(for: activeFilter)) {
                        viewModel.clear(activeFilter)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func list(_ sections: [IncidentDaySection]) -> some View {
        List {
            ForEach(sections) { section in
                Section(section.title) {
                    ForEach(section.incidents) { incident in
                        Button {
                            onSelect(incident)
                        } label: {
                            IncidentRow(incident: incident)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }

    private var noIncidentsState: some View {
        ContentUnavailableView(
            "Brak zgłoszeń",
            systemImage: "tray",
            description: Text("Dodaj pierwsze zgłoszenie przyciskiem +.")
        )
    }

    private var noResultsState: some View {
        ContentUnavailableView(
            "Brak pasujących zgłoszeń",
            systemImage: "line.3.horizontal.decrease.circle",
            description: Text("Zmień wyszukiwanie lub filtry.")
        )
    }
}

#Preview("Lista") {
    IncidentListView(
        viewModel: IncidentListViewModel(),
        incidents: Incident.makeSamples(),
        userLocation: nil,
        onSelect: { _ in }
    )
}

#Preview("Pusta") {
    IncidentListView(
        viewModel: IncidentListViewModel(),
        incidents: [],
        userLocation: nil,
        onSelect: { _ in }
    )
}
