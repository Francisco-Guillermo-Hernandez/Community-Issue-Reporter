
import SwiftUI

enum InsightsNavigation: Hashable {
    case myReports
    case myPetitions
    case activity(date: String)
    case noActivity
}
