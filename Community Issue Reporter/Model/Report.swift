//
//  Report.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
// Enhanced by Francisco Hernandez
//

import Foundation

// MARK: - Possible states of a report
enum ReportStates: String, Codable {
    case new
    case inProgress
    case resolved
    case rejected
    case awaitingReview
    case modifying
}


struct Report: Identifiable, Codable {
    var id: String?
    var coordinate: Coordinate
    var address: String
    var title: String
    var description: String
    var severityId: Int
    var statusId: Int
    var issueTypeId: Int
    var matterToSolveId: Int
    var reportedAt: Date?
    var cellIndex: String
    var createdAt: Date?
    var updatedAt: Date?
    var reportedBy: String?
    var olc: String?
    var suggestedTitle: String?
    var suggestedDescription: String?
    var reportState: ReportStates?
    init(
            id: String? = nil,
            coordinate: Coordinate,
            address: String,
            title: String,
            description: String,
            severityId: Int,
            statusId: Int,
            issueTypeId: Int,
            matterToSolveId: Int,
            reportedAt: Date? = nil,
            cellIndex: String,
            olc: String? = nil,
            createdAt: Date? = nil,
            updatedAt: Date? = nil,
            reportedBy: String? = nil,
            suggestedTitle: String? = nil,
            suggestedDescription: String? = nil,
            reportState: ReportStates? = .new
        ) {
            self.id = id
            self.coordinate = coordinate
            self.address = address
            self.title = title
            self.description = description
            self.severityId = severityId
            self.statusId = statusId
            self.issueTypeId = issueTypeId
            self.matterToSolveId = matterToSolveId
            self.reportedAt = reportedAt
            self.cellIndex = cellIndex
            self.olc = olc
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.reportedBy = reportedBy
            self.suggestedTitle = suggestedTitle
            self.suggestedDescription = suggestedDescription
            self.reportState = reportState
        }
}

// MARK: - Extension to use related values of the enums
extension Report {
    var issueType: IssueTypes {
        get {
            IssueTypes.allCases.first(where: { $0.identifier == self.issueTypeId }) ?? .all
        }
        
        set {
            self.issueTypeId = newValue.identifier
        }
    }
    
    
    var severity: Severity {
          get {
              Severity.allCases.first(where: { $0.identifier == self.severityId }) ?? .low
          }
          set {
              // When the picker updates 'severity', we update the underlying 'severityId'
              self.severityId = newValue.identifier
          }
      }

    var status: IssueStatus {
        get {
            IssueStatus.allCases.first(where: { $0.identifier == self.statusId }) ?? .reported
        }
        
        set {
            self.statusId = newValue.identifier
        }
    }
    
    var reportedDate: String {
       if reportedAt == nil {
            String(localized: "Not yet")
       } else {
           formatRelativeDate(from: self.reportedAt ?? Date())
       }
    }
    
    var createdDate: String {
        formatRelativeDate(from: self.createdAt ?? Date())
    }
    
    var updatedDate: String {
        formatRelativeDate(from: self.updatedAt ?? Date())
    }
}
