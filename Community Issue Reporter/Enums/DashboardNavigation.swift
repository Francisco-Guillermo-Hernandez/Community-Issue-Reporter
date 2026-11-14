//
//  DashboardNavigation.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/11/26.
//

import Foundation

enum DashboardNavigation: String, Equatable, Hashable, Identifiable {
    
    case reports
    case profile
    
    static let mainPages: [DashboardNavigation] = [.reports, .profile]
    
    var id: String {
        switch self {
            case .reports: return "reports"
            case .profile: return "profile"
        }
    }
    
    var name: String {
        switch self {
            case .reports: return String(localized: "Reports")
            case .profile: return String(localized: "Profile")
        }
    }
    
    var symbolName: String {
        switch self {
            case .reports: "map"
            case .profile: "person.fill"
        }
    }
    
    /// A view builder that the split view uses to show a view for the selected navigation option.
//    @MainActor @ViewBuilder func viewForPage() -> some View {
//        switch self {
//        case .landmarks: LandmarksView()
//        case .map: MapView()
//        case .collections: CollectionsView()
//        }
//        
//    }
}
