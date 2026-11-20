import Foundation
import CoreLocation
import Observation

struct IncidentDaySection: Identifiable {
    let day: Date
    let incidents: [Incident]

    var id: Date { day }

    var title: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) { return "Dzisiaj" }
        if calendar.isDateInYesterday(day) { return "Wczoraj" }
        return day.formatted(.dateTime.day().month(.wide))
    }
}

enum ActiveFilter: String, CaseIterable, Identifiable {
    case time
    case radius
    case categories

    var id: String { rawValue }
}

@Observable
final class IncidentListViewModel {

    private static let addressRefreshDistance: CLLocationDistance = 200

    var searchText = ""
    var filter = IncidentFilter()
    var isFilterSheetPresented = false
    private(set) var locationName: String?

    @ObservationIgnored private var lastGeocodedLocation: CLLocation?

    // MARK: - List

    func sections(from incidents: [Incident], userLocation: CLLocation?) -> [IncidentDaySection] {
        let visible = incidents.filter {
            matchesSearch($0) && filter.matches($0, userLocation: userLocation)
        }
        let calendar = Calendar.current
        let byDay = Dictionary(grouping: visible) { calendar.startOfDay(for: $0.date) }

        return byDay.keys.sorted(by: >).map { day in
            IncidentDaySection(
                day: day,
                incidents: byDay[day, default: []].sorted { $0.date > $1.date }
            )
        }
    }

    private func matchesSearch(_ incident: Incident) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return [incident.location, incident.line, incident.vehicleNumber]
            .contains { $0.localizedStandardContains(query) }
    }

    // MARK: - Subtitle

    var subtitle: String {
        let place = locationName ?? "Twoja lokalizacja"
        guard filter.usesMyLocation else { return place }
        return "\(place) · w promieniu \(IncidentFilter.distanceText(filter.radius))"
    }

    func updateLocationName(for location: CLLocation?) async {
        guard let location else { return }
        if let lastGeocodedLocation,
           location.distance(from: lastGeocodedLocation) < Self.addressRefreshDistance {
            return
        }
        let placemark = try? await CLGeocoder().reverseGeocodeLocation(location).first
        guard let address = placemark?.shortAddress else { return }
        lastGeocodedLocation = location
        locationName = address
    }

    // MARK: - Active filters

    var activeFilters: [ActiveFilter] {
        ActiveFilter.allCases.filter { isActive($0) }
    }

    func title(for activeFilter: ActiveFilter) -> String {
        switch activeFilter {
        case .time:
            return filter.timeRange?.chipTitle ?? ""
        case .radius:
            return "Do \(IncidentFilter.distanceText(filter.radius))"
        case .categories:
            return "Kategorie: \(filter.categories.count)"
        }
    }

    func clear(_ activeFilter: ActiveFilter) {
        switch activeFilter {
        case .time:       filter.timeRange = nil
        case .radius:     filter.usesMyLocation = false
        case .categories: filter.categories = Set(IncidentCategory.allCases)
        }
    }

    private func isActive(_ activeFilter: ActiveFilter) -> Bool {
        switch activeFilter {
        case .time:       return filter.timeRange != nil
        case .radius:     return filter.usesMyLocation
        case .categories: return !filter.hasAllCategories
        }
    }
}
