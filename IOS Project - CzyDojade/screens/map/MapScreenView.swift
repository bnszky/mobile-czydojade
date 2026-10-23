import SwiftUI
import MapKit

struct MapScreenView: View {

    @State private var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .region(MapViewModel.wroclawRegion)
    @State private var showSatellite = false

    private let cream = Color(red: 0.99, green: 0.90, blue: 0.80)

    var body: some View {
        Map(position: $position) {
            ForEach(viewModel.incidents) { incident in
                Annotation(incident.location, coordinate: incident.coordinate) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(
                            viewModel.selectedID == incident.id ? Color.red : Color.orange,
                            in: Circle()
                        )
                        .shadow(radius: 3)
                        .onTapGesture { viewModel.selectedID = incident.id }
                }
            }
        }
        .mapStyle(showSatellite ? .hybrid : .standard)
        .mapControls { }
        .overlay(alignment: .trailing) { mapButtons }
        .safeAreaInset(edge: .bottom, spacing: 12) { bottomArea }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.selectedID) {
            focusOnSelected()
        }
    }

    private var mapButtons: some View {
        VStack(spacing: 14) {
            circleButton(systemName: "location.fill") {
                withAnimation { position = .region(MapViewModel.wroclawRegion) }
            }
            circleButton(systemName: "square.2.layers.3d") {
                showSatellite.toggle()
            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 260)
    }

    private func circleButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 50, height: 50)
                .background(.white, in: Circle())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }

    private var bottomArea: some View {
        VStack(spacing: 14) {
            carousel
            //tabBar
        }
    }

    private var carousel: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.incidents) { incident in
                    IncidentCardView(incident: incident)
                        .containerRelativeFrame(.horizontal) { length, _ in length - 40 }
                        .id(incident.id)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, 20, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $viewModel.selectedID)
        .scrollIndicators(.hidden)
        .frame(height: 300)
    }

//    private var tabBar: some View {
//        HStack {
//            tabItem(icon: "map", title: "Mapa") { }
//            Spacer()
//            Color.clear.frame(width: 70)
//            Spacer()
//            tabItem(icon: "list.bullet", title: "Lista") { }
//        }
//        .padding(.horizontal, 36)
//        .padding(.vertical, 10)
//        .background(.ultraThinMaterial, in: Capsule())
//        .overlay(alignment: .top) {
//            Button { } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "plus")
//                        .font(.system(size: 26, weight: .regular))
//                        .foregroundStyle(.black)
//                        .frame(width: 64, height: 64)
//                        .background(cream, in: Circle())
//                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
//                    Text("Dodaj")
//                        .font(.system(size: 11))
//                        .foregroundStyle(.black)
//                }
//            }
//            .offset(y: -24)
//        }
//        .padding(.horizontal, 20)
//    }
//
//    private func tabItem(icon: String, title: String, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            VStack(spacing: 4) {
//                Image(systemName: icon).font(.system(size: 22))
//                Text(title).font(.system(size: 11))
//            }
//            .foregroundStyle(.black)
//        }
//    }


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
