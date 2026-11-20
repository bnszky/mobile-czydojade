import SwiftUI

struct IncidentListView: View {

    let incidents: [Incident]
    let onSelect: (Incident) -> Void
    var onFilters: () -> Void = {}

    @State private var viewModel = IncidentListViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if incidents.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .background(Theme.Colors.screenBackground)
    }

    private var header: some View {
        HStack {
            Text("Zgłoszenia")
                .font(.largeTitle.bold())

            Spacer()

            Button(action: onFilters) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: Theme.FontSize.toolbarIcon, weight: .semibold))
                    .foregroundStyle(Theme.Colors.accent)
                    .frame(width: Theme.Size.toolbarButton, height: Theme.Size.toolbarButton)
                    .background(Theme.Colors.surface, in: Circle())
            }
            .accessibilityLabel("Filtry")
        }
        .padding(.horizontal, Theme.Spacing.screenHorizontal)
    }

    private var list: some View {
        List {
            ForEach(viewModel.sections(from: incidents)) { section in
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
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "Brak zgłoszeń",
            systemImage: "tray",
            description: Text("Dodaj pierwsze zgłoszenie przyciskiem +.")
        )
    }
}

#Preview("Lista") {
    IncidentListView(incidents: Incident.makeSamples(), onSelect: { _ in })
}

#Preview("Pusta") {
    IncidentListView(incidents: [], onSelect: { _ in })
}
