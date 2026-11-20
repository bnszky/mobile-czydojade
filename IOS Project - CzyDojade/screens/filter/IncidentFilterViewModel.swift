import Foundation
import Observation

@Observable
final class IncidentFilterViewModel {

    var draft: IncidentFilter

    init(filter: IncidentFilter) {
        draft = filter
    }

    func isSelected(_ category: IncidentCategory) -> Bool {
        draft.categories.contains(category)
    }

    func toggle(_ category: IncidentCategory) {
        if isSelected(category) {
            draft.categories.remove(category)
        } else {
            draft.categories.insert(category)
        }
    }

    func reset() {
        draft = IncidentFilter()
    }

    var categoriesFooter: String {
        "Wybrano \(draft.categories.count) z \(IncidentCategory.allCases.count) kategorii."
    }

    var timeFooter: String {
        switch draft.timeRange {
        case .lastHour: return "Pokazujemy zgłoszenia z ostatniej godziny."
        case .lastDay:  return "Pokazujemy zgłoszenia z ostatnich 24 godzin."
        case .lastWeek: return "Pokazujemy zgłoszenia z ostatnich 7 dni."
        case .custom:   return "Pokazujemy zgłoszenia z wybranych dni."
        case nil:       return "Pokazujemy zgłoszenia z dowolnego czasu."
        }
    }

    var radiusText: String {
        IncidentFilter.distanceText(draft.radius)
    }

    var minRadiusText: String {
        IncidentFilter.distanceText(IncidentFilter.radiusRange.lowerBound)
    }

    var maxRadiusText: String {
        IncidentFilter.distanceText(IncidentFilter.radiusRange.upperBound)
    }
}
