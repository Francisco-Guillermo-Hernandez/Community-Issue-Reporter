//
//  NavigationManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/6/26.
//

import SwiftUI
internal import Combine

enum AppScreen: Hashable {
    case welcome
    case details(itemID: String)
    case report(id: String)
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        // Parse your custom push payload keys
        if let itemID = userInfo["item_id"] as? String {
            // Clear existing stack or append to deep-link
            path.append(AppScreen.details(itemID: itemID))
        }
    }
}

class AccessoryHandler: ObservableObject {
    @Published var isEnabled: Bool = false
    
    func showAccessory() {
        isEnabled = true
    }
}


class ReportDetailsHandler: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var report: MapExplorerReport = .init(id: "", lat: 0, lng: 0, address: "", title: "", description: "", severityId: 1, statusId: 1, issueTypeId: 1, matterToSolveId: 1, reportedAtRaw: 0, cellIndex: "", createdAtRaw: 0, updatedAtRaw: 0, reportedBy: "", cityId: "", petitionId: "")
    @Published var isLoading: Bool = false
    
    
    func showDetails(of report: MapExplorerReport) {
//        self.isPresented = true
        self.report = report
    }
}
