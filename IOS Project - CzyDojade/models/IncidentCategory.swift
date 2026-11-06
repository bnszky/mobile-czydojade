import SwiftUI

enum IncidentCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case breakdown
    case blockage
    case delay
    case inspection
    case vehicleCondition
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .breakdown:        return "Awaria / wypadek"
        case .blockage:         return "Blokada"
        case .delay:            return "Opóźnienie"
        case .inspection:       return "Kontrola biletów"
        case .vehicleCondition: return "Stan pojazdu"
        case .other:            return "Inne"
        }
    }

    var systemImage: String {
        switch self {
        case .breakdown:        return "exclamationmark.triangle.fill"
        case .blockage:         return "nosign"
        case .delay:            return "clock.badge.exclamationmark"
        case .inspection:       return "ticket.fill"
        case .vehicleCondition: return "wrench.and.screwdriver.fill"
        case .other:            return "questionmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .breakdown:        return .red
        case .blockage:         return .orange
        case .delay:            return .purple
        case .inspection:       return .blue
        case .vehicleCondition: return .teal
        case .other:            return .gray
        }
    }
}
