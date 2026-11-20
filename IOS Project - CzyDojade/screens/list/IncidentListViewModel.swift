import Foundation
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

@Observable
final class IncidentListViewModel {

    func sections(from incidents: [Incident]) -> [IncidentDaySection] {
        let calendar = Calendar.current
        let byDay = Dictionary(grouping: incidents) { calendar.startOfDay(for: $0.date) }

        return byDay.keys.sorted(by: >).map { day in
            IncidentDaySection(
                day: day,
                incidents: byDay[day, default: []].sorted { $0.date > $1.date }
            )
        }
    }
}
