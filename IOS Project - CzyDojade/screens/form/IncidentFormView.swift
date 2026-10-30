import SwiftUI
import MapKit

struct IncidentFormView: View {

    @State private var viewModel: IncidentFormViewModel
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss

    let onSave: (Incident) -> Void
    let onDelete: ((Incident) -> Void)?

    init(
        mode: IncidentFormMode,
        onSave: @escaping (Incident) -> Void,
        onDelete: ((Incident) -> Void)? = nil
    ) {
        _viewModel = State(initialValue: IncidentFormViewModel(mode: mode))
        self.onSave = onSave
        self.onDelete = onDelete
    }

    var body: some View {
        NavigationStack {
            Form {
                vehicleSection
                placeSection
                eventSection
                imageSection
                if viewModel.isEditing, onDelete != nil {
                    deleteSection
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") {
                        onSave(viewModel.makeIncident())
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .confirmationDialog(
                "Usunąć to zgłoszenie?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Usuń", role: .destructive) {
                    onDelete?(viewModel.makeIncident())
                    dismiss()
                }
            }
        }
    }


    private var vehicleSection: some View {
        Section("Pojazd") {
            TextField("Linia, np. Linia 23 (3312)", text: $viewModel.line)
        }
    }

    private var placeSection: some View {
        Section {
            TextField("Lokalizacja, np. Centrum, Legnicka 24", text: $viewModel.location)

            MapReader { proxy in
                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: viewModel.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                    )
                )) {
                    Marker(
                        viewModel.location.isEmpty ? "Zgłoszenie" : viewModel.location,
                        systemImage: "exclamationmark.triangle.fill",
                        coordinate: viewModel.coordinate
                    )
                    .tint(.red)
                }
                .onTapGesture { point in
                    if let coordinate = proxy.convert(point, from: .local) {
                        viewModel.coordinate = coordinate
                    }
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        } header: {
            Text("Miejsce")
        } footer: {
            Text("Dotknij mapy, aby ustawić pinezkę.")
        }
    }

    private var eventSection: some View {
        Section("Zdarzenie") {
            TextField("Opis", text: $viewModel.details, axis: .vertical)
                .lineLimit(2...4)
            DatePicker("Kiedy", selection: $viewModel.date)
            Toggle("Oznacz jako ostatnie", isOn: $viewModel.isRecent)
        }
    }

    private var imageSection: some View {
        Section {
            TextField("Adres zdjęcia (https://…)", text: $viewModel.imageURLText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.URL)

            if let url = URL(string: viewModel.imageURLText), viewModel.isImageURLValid,
               !viewModel.imageURLText.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Label("Nie udało się wczytać zdjęcia", systemImage: "photo")
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        } header: {
            Text("Zdjęcie (opcjonalne)")
        } footer: {
            if !viewModel.isImageURLValid {
                Text("Podaj poprawny adres zaczynający się od http lub https.")
                    .foregroundStyle(.red)
            }
        }
    }

    private var deleteSection: some View {
        Section {
            Button("Usuń zgłoszenie", role: .destructive) {
                showDeleteConfirmation = true
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("Nowe") {
    IncidentFormView(mode: .create, onSave: { _ in })
}

#Preview("Edycja") {
    IncidentFormView(
        mode: .edit(MapViewModel.sample[0]),
        onSave: { _ in },
        onDelete: { _ in }
    )
}
