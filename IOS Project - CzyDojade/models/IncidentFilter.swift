import Foundation
import CoreLocation

enum IncidentTimeRange: String, CaseIterable, Identifiable {
    case lastHour
    case lastDay
    case lastWeek
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lastHour: return "1 h"
        case .lastDay:  return "24 h"
        case .lastWeek: return "7 dni"
        case .custom:   return "Zakres"
        }
    }

    var chipTitle: String {
        switch self {
        case .lastHour: return "Ostatnia godzina"
        case .lastDay:  return "Ostatnie 24 h"
        case .lastWeek: return "Ostatnie 7 dni"
        case .custom:   return "Własny zakres"
        }
    }

    func startDate(before now: Date) -> Date? {
        let calendar = Calendar.current
        switch self {
        case .lastHour: return calendar.date(byAdding: .hour, value: -1, to: now)
        case .lastDay:  return calendar.date(byAdding: .day, value: -1, to: now)
        case .lastWeek: return calendar.date(byAdding: .day, value: -7, to: now)
        case .custom:   return nil
        }
    }
}

struct IncidentFilter: Equatable {

    static let radiusRange: ClosedRange<Double> = 500...10_000
    static let radiusStep: Double = 500
    static let defaultRadius: Double = 2_000
    private static let metersPerKilometer: Double = 1_000

    var categories = Set(IncidentCategory.allCases)
    var timeRange: IncidentTimeRange? = .lastDay
    var customStart = Calendar.current.startOfDay(for: .now)
    var customEnd = Date.now
    var radius = defaultRadius
    var usesMyLocation = true

    var hasAllCategories: Bool {
        categories.count == IncidentCategory.allCases.count
    }

    func matches(_ incident: Incident, userLocation: CLLocation?, now: Date = .now) -> Bool {
        categories.contains(incident.category)
        && matchesTime(incident.date, now: now)
        && matchesDistance(incident.coordinate, from: userLocation)
    }

    private func matchesTime(_ date: Date, now: Date) -> Bool {
        guard let timeRange else { return true }
        guard timeRange == .custom else {
            return date >= (timeRange.startDate(before: now) ?? .distantPast)
        }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: customStart)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: customEnd)) ?? customEnd
        return date >= start && date < endOfDay
    }

    private func matchesDistance(_ coordinate: CLLocationCoordinate2D, from userLocation: CLLocation?) -> Bool {
        guard usesMyLocation, let userLocation else { return true }
        let incidentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return incidentLocation.distance(from: userLocation) <= radius
    }

    static func distanceText(_ meters: Double) -> String {
        guard meters >= metersPerKilometer else {
            return "\(meters.formatted(.number.precision(.fractionLength(0)))) m"
        }
        let kilometers = meters / metersPerKilometer
        return "\(kilometers.formatted(.number.precision(.fractionLength(0...1)))) km"
    }
}
