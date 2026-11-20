import SwiftUI

struct IncidentFilterView: View {

    @State private var viewModel: IncidentFilterViewModel
    @Environment(\.dismiss) private var dismiss

    let onApply: (IncidentFilter) -> Void

    init(filter: IncidentFilter, onApply: @escaping (IncidentFilter) -> Void) {
        _viewModel = State(initialValue: IncidentFilterViewModel(filter: filter))
        self.onApply = onApply
    }

    var body: some View {
        NavigationStack {
            Form {
                categoriesSection
                timeSection
                radiusSection
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Wyczyść") { viewModel.reset() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onApply(viewModel.draft)
                        dismiss()
                    } label: {
                        Label("Zastosuj", systemImage: "checkmark")
                    }
                }
            }
        }
    }

    private var categoriesSection: some View {
        Section {
            ForEach(IncidentCategory.allCases) { category in
                Button {
                    viewModel.toggle(category)
                } label: {
                    HStack(spacing: Theme.Spacing.rowContent) {
                        CategoryIcon(category: category, size: Theme.Size.categoryIconMedium)
                        Text(category.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        if viewModel.isSelected(category) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Theme.Colors.accent)
                        }
                    }
                }
            }
        } header: {
            Text("Kategorie")
        } footer: {
            Text(viewModel.categoriesFooter)
        }
    }

    private var timeSection: some View {
        Section {
            Picker("Kiedy", selection: $viewModel.draft.timeRange) {
                ForEach(IncidentTimeRange.allCases) { range in
                    Text(range.title).tag(Optional(range))
                }
            }
            .pickerStyle(.segmented)

            if viewModel.draft.timeRange == .custom {
                DatePicker("Od", selection: $viewModel.draft.customStart, displayedComponents: .date)
                DatePicker("Do", selection: $viewModel.draft.customEnd, in: viewModel.draft.customStart..., displayedComponents: .date)
            }
        } header: {
            Text("Kiedy")
        } footer: {
            Text(viewModel.timeFooter)
        }
    }

    private var radiusSection: some View {
        Section("Promień") {
            LabeledContent("Odległość") {
                Text(viewModel.radiusText)
                    .foregroundStyle(Theme.Colors.accent)
            }

            VStack(spacing: Theme.Spacing.rowText) {
                Slider(
                    value: $viewModel.draft.radius,
                    in: IncidentFilter.radiusRange,
                    step: IncidentFilter.radiusStep
                )
                HStack {
                    Text(viewModel.minRadiusText)
                    Spacer()
                    Text(viewModel.maxRadiusText)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .disabled(!viewModel.draft.usesMyLocation)

            Toggle("Od mojej lokalizacji", isOn: $viewModel.draft.usesMyLocation)
        }
    }
}

#Preview {
    IncidentFilterView(filter: IncidentFilter(), onApply: { _ in })
}
