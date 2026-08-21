import SwiftUI
import Observation

enum ProfileDestinations: Hashable {
    case reports
    case comments
    case signPetitions
    case settings
    case licenses
    case moderation
    case timeline(reportId: String)
}

@Observable
@MainActor
final class ProfileRouter {
    static let shared = ProfileRouter()
    
    var path: [ProfileDestinations] = []
    
    private init() {}
    
    func goTo(_ destination: ProfileDestinations) {
        path.append(destination)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
