import SwiftUI
import Observation
 
@Observable
final class LandingViewModel {
    var imageURL: URL?
    var title: String
    var description: String
    var buttonTitle: String
 
    init(
        imageURL: URL? = URL(string: "https://visitwroclaw.eu/wp-content/uploads/2025/07/Wroclaw-z-tramwajem-1.png"),
        title: String = "Czy Dojadę?",
        description: String = "Dowiedz się o problemach wcześniej niż inni",
        buttonTitle: String = "Start"
    ) {
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
    }
}
