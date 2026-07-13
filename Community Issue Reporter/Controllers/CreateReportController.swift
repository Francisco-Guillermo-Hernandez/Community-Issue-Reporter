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
    
}
