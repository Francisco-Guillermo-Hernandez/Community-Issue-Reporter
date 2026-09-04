//
//  CreateReportController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/7/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CreateReportController {
        
    var searchText = ""
    var issueType: IssueTypes = .all
    var severity: Severity = .all
    var feedbackTrigger = false
    var showReportsLimitSheet: Bool = false
    private var settings = SettingsStore.shared
    private(set) var reportsCount: Int = 0
    
    var filteredMatters: [MatterToSolve] {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            return filterByIssueType(matter: filterByStatus(matter: mattersToResolve))
        }
        
        return mattersToResolve.filter { matter in
            matter.title.localizedCaseInsensitiveContains(trimmedQuery)
            || matter.description.localizedCaseInsensitiveContains(trimmedQuery)
            
        }
    }
    
    private func checkState() -> Void {
        
        let planType = KeychainService.getToken(.planType)
        
        if planType.isEmpty || planType == PlanType.freemium.rawValue {
            if reportsCount >= MAX_REPORTS_PER_REGISTERED_USERS {
                showReportsLimitSheet = true
            } else {
                showReportsLimitSheet = false
            }
        } else if planType == PlanType.freemiumForGuests.rawValue {
            
            if reportsCount >= MAX_REPORTS_PER_UNREGISTERED_USERS {
                showReportsLimitSheet = true
            } else {
                showReportsLimitSheet = false
            }
            
        } else {
           if reportsCount <= MAX_REPORTS_PER_PAID_USERS {
                showReportsLimitSheet = false
           } else {
               showReportsLimitSheet = true
           }
        }
    }
    
    func getReportsCount() async -> Void {
        if UserRepository.shared.isGuestUser() {
            let currentDate = Date()
            let calendar = Calendar.current
            
            if let lastDate = settings.lastReportDate {
                let currentMonth = calendar.component(.month, from: currentDate)
                let currentYear = calendar.component(.year, from: currentDate)
                let lastMonth = calendar.component(.month, from: lastDate)
                let lastYear = calendar.component(.year, from: lastDate)
                
                if currentMonth != lastMonth || currentYear != lastYear {
                    settings.reportsCount = 0
                }
            }
            
            reportsCount = settings.reportsCount
        } else {
            SubscriptionManager.shared.checkEntitlement()
            let reportCount = await CounterRepository.shared.count()
             
             if let reportCount {
                 reportsCount = reportCount
                 print("count: \(reportCount)")
             } else {
                 reportsCount = settings.reportsCount
             }
        }
        
        print("count: \(reportsCount)")
        
        /// Evaluates
       checkState()
    }
    
    func filterByStatus(matter: [MatterToSolve]) -> [MatterToSolve] {
        return matter.filter { matter in
            matter.severity == self.severity || self.severity == .all
        }
    }
    
    func filterByIssueType(matter: [MatterToSolve]) -> [MatterToSolve] {
        return matter.filter { matter in
            matter.issueType == self.issueType || self.issueType == .all
        }
    }
    
    func handleSheetDismissal() -> Void {
        /// Only re-evaluate if the user is still on the report tab.
        /// If they were routed away, we shouldn't force the sheet back open.
        if DeepLinkRouter.shared.activeTab != 1 {
            checkState()
        }
    }
    
    func handleUserAction(_ interaction: InteractionType) -> Void {
        
        if interaction == .paidASubscription {
            showReportsLimitSheet = false
        }
        
        if interaction == .viewAd {
            reportsCount -= 1
            showReportsLimitSheet = false
        }
        
        if interaction == .noThanks {
            noThanks()
        }
        
    }
    
    private func noThanks() -> Void {
        Task {
            showReportsLimitSheet = false
            try? await Task.sleep(for: .milliseconds(64))
            DeepLinkRouter.shared.activeTab = 1
        }
    }
    
}
