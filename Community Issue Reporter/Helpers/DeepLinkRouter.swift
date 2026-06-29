//
//  DeepLinkRouter.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI
internal import Combine

@MainActor
class DeepLinkRouter: ObservableObject {
    @Published var pendingDeepLink: DeepLink?
    @Published var activeReportID: String?
    @Published var activeTab: Int = 0
    @Published var isPresented: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    @Published var report: MapExplorerReport = .init(id: "", lat: 0, lng: 0, address: "", title: "", description: "", severityId: 1, statusId: 1, issueTypeId: 1, matterToSolveId: 1, reportedAtRaw: 0, cellIndex: "", createdAtRaw: 0, updatedAtRaw: 0, reportedBy: "", cityId: "", petitionId: "", shareUrl: "",
                                                     attachments: [])
    @Published var presentAlert: Bool = false
    @Published var isReadyToRoute: Bool = false
    
    func handleIncomingURL(_ url: URL) {
        
       
        /// Parse the deep link
        guard let deepLink = deepLinkHandler(url) else { return }
        
        if isReadyToRoute {
            /// App is already open and ready, route it instantly
            route(deepLink)
        } else {
            /// Cold start or view not ready: Save it for later!
            self.pendingDeepLink = deepLink
        }
    }
    
    func processPendingDeepLink() {
        
        // Called when TabBarView finally appears
        guard let deepLink = pendingDeepLink else { return }
        route(deepLink)
        
        self.pendingDeepLink = nil
    }
    
    private func route(_ deepLink: DeepLink) {
        switch deepLink.type {
        case .report:
            self.activeTab = 1
            self.activeReportID = deepLink.reportId
            print("Active report ID: \(activeReportID ?? "nil")")
            guard let reportId = activeReportID else { return }
            
            retrieveAndPresentReportDetails(of: reportId)
        case .petition, .updateInfo, .unknown:
            break
        }
    }
    
    private func dismissAndShowAlert(message: String) async {
        self.message = message
        self.isLoading = false
        if self.isPresented {
            self.isPresented = false
            // Wait for the sheet dismissal animation to finish before presenting the alert
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
        self.presentAlert = true
    }
    
    private func retrieveAndPresentReportDetails(of reportId: String) {
        Task {

        self.isLoading = true
        
            do {
                self.isPresented = true
                let result = try await MapExplorerRepository.shared.report(reportId, countryCode: .SV, cityId: "")
                self.report = result
                
            } catch CommonIntercommunicationErrors.invalidPetition {
                await dismissAndShowAlert(message: String(localized: "That link is invalid"))
            } catch CommonIntercommunicationErrors.notFound {
                await dismissAndShowAlert(message: String(localized: "That link does not exist"))
            } catch {
                await dismissAndShowAlert(message: String(localized: "Something went wrong"))
            }
            
            isLoading = false
        }
    }
}
