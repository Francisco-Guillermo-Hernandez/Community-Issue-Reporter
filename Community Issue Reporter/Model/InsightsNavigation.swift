
import SwiftUI

enum InsightsNavigation: Hashable {
    case myReports
    case myPetitions
    case activity(date: String)
    case noActivity
    case report(Report)
    case petition(Petition)
}
