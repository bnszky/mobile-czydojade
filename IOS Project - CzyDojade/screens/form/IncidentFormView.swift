import SwiftUI
import MapKit
import PhotosUI
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
            .listRowInsets(Theme.Insets.formMedia)
        } header: {
            Text("Miejsce")
        } footer: {
            Text("Dotknij mapy, aby przesunąć pinezkę. Adres uzupełni się sam.")
        }
    }

    private var eventSection: some View {
        Section("Zdarzenie") {
            LabeledContent("Kategoria") {
                Menu {
                    Picker("Kategoria", selection: $viewModel.category) {
                        ForEach(IncidentCategory.allCases) { category in
                            Label(category.title, systemImage: category.systemImage)
                                .tag(category)
                        }
                    }
                } label: {
                    HStack(spacing: Theme.Spacing.rowMeta) {
                        CategoryIcon(category: viewModel.category, size: Theme.Size.categoryIconMedium)
                        Text(viewModel.category.title)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.footnote)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            TextField("Opis", text: $viewModel.details, axis: .vertical)
                .lineLimit(2...4)
            DatePicker("Kiedy", selection: $viewModel.date)
        }
    }

    private var imageSection: some View {
        Section {
            if viewModel.isLoadingPhoto {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if viewModel.hasImage {
                IncidentPhoto(imageData: viewModel.imageData, imageURL: viewModel.imageURL)
                    .frame(height: Theme.Size.formImagePreviewHeight)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.formMedia, style: .continuous))
                    .listRowInsets(Theme.Insets.formMedia)
            }

            PhotosPicker(selection: $viewModel.photoSelection, matching: .images) {
                Label(
                    viewModel.hasImage ? "Zmień zdjęcie" : "Wybierz z galerii",
                    systemImage: "photo.on.rectangle"
                )
            }

            if viewModel.hasImage {
                Button("Usuń zdjęcie", role: .destructive) {
                    viewModel.removePhoto()
                }
            }
        } header: {
            Text("Zdjęcie (opcjonalne)")
        } footer: {
            if viewModel.photoLoadFailed {
                Text("Nie udało się wczytać zdjęcia. Spróbuj wybrać inne.")
                    .foregroundStyle(.red)
            }
        }
        .onChange(of: viewModel.photoSelection) {
            viewModel.loadSelectedPhoto()
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
