import CoreLocation

extension CLPlacemark {
    var shortAddress: String? {
        let street = [thoroughfare, subThoroughfare]
            .compactMap { $0 }
            .joined(separator: " ")
        let parts = [subLocality ?? locality, street.isEmpty ? nil : street]
            .compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}
