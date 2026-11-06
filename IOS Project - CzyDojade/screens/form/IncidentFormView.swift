import SwiftUI
import MapKit
import SwiftData

struct IncidentFormView: View {

    @State private var viewModel: IncidentFormViewModel
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let onSave: (Incident) -> Void

    init(
        mode: IncidentFormMode,
        userCoordinate: CLLocationCoordinate2D? = nil,
        onSave: @escaping (Incident) -> Void = { _ in }
    ) {
        _viewModel = State(
            initialValue: IncidentFormViewModel(mode: mode, userCoordinate: userCoordinate)
        )
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                vehicleSection
                placeSection
                eventSection
                imageSection
                if viewModel.isEditing {
                    deleteSection
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .task { viewModel.resolveInitialAddress() }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") {
                        let saved = viewModel.save(in: context)
                        onSave(saved)
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
                    viewModel.delete(in: context)
                    dismiss()
                }
            }
        }
    }

    private var vehicleSection: some View {
        Section("Pojazd") {
            LabeledContent("Linia") {
                TextField("np. 23", text: $viewModel.line)
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
            }
            LabeledContent("Numer pojazdu") {
                TextField("np. 3312 (opcjonalnie)", text: $viewModel.vehicleNumber)
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
    }

    private var placeSection: some View {
        Section {
            LabeledContent("Adres") {
                TextField("Uzupełnia się z mapy", text: $viewModel.location, axis: .vertical)
                    .multilineTextAlignment(.trailing)
            }

            MapReader { proxy in
                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: viewModel.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                    )
                )) {
                    Marker(
                        viewModel.location.isEmpty ? "Zgłoszenie" : viewModel.location,
                        systemImage: viewModel.category.systemImage,
                        coordinate: viewModel.coordinate
                    )
                    .tint(viewModel.category.color)
                }
                .onTapGesture { point in
                    if let coordinate = proxy.convert(point, from: .local) {
                        viewModel.setCoordinate(coordinate)
                    }
                }
            }
            .frame(height: Theme.Size.cardImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.formMedia, style: .continuous))
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        } header: {
            Text("Miejsce")
        } footer: {
            Text("Dotknij mapy, aby przesunąć pinezkę. Adres uzupełni się sam.")
        }
    }

    private var eventSection: some View {
        Section("Zdarzenie") {
            Picker("Kategoria", selection: $viewModel.category) {
                ForEach(IncidentCategory.allCases) { category in
                    Label(category.title, systemImage: category.systemImage)
                        .tag(category)
                }
            }
            TextField("Opis", text: $viewModel.details, axis: .vertical)
                .lineLimit(2...4)
            DatePicker("Kiedy", selection: $viewModel.date)
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
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.formMedia, style: .continuous))
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
    IncidentFormView(mode: .create)
        .modelContainer(for: Incident.self, inMemory: true)
}

#Preview("Edycja") {
    IncidentFormView(mode: .edit(Incident.makeSamples()[0]))
        .modelContainer(for: Incident.self, inMemory: true)
}
