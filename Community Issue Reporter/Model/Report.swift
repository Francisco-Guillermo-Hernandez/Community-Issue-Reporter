//
//  Report.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
// Enhanced by Francisco Hernandez
//

import Foundation
import Observation

// MARK: - Possible states of a report
enum ReportStates: String, Codable, CaseIterable {
    case new
    case inProgress
    case resolved
    case rejected
    case awaitingReview
    case modifying
}

@Observable
final class Report: Identifiable, Codable, Hashable {
    
    static func == (lhs: Report, rhs: Report) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
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
    var attachments: [PreviewAttachmentRequest]
    var cityId: String?
    var reportContainer: String?
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
            reportState: ReportStates? = .new,
            attachments: [PreviewAttachmentRequest] = [],
            cityId: String? = nil,
            reportContainer: String? = nil
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
            self.attachments = attachments
            self.cityId = cityId
            self.reportContainer = reportContainer
        }
}


struct ReportDAO: Identifiable, Codable {
    
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
    var attachments: [PreviewAttachmentRequest]
    var cityId: String?
    var reportContainer: String?
    
    init(_ report: Report) {
        self.id = report.id
        self.coordinate = report.coordinate
        self.address = report.address
        self.title = report.title
        self.description = report.description
        self.severityId = report.severityId
        self.statusId = report.statusId
        self.issueTypeId = report.issueTypeId
        self.matterToSolveId = report.matterToSolveId
        self.reportedAt = report.reportedAt
        self.cellIndex = report.cellIndex
        self.olc = report.olc
        self.createdAt = report.createdAt
        self.updatedAt = report.updatedAt
        self.reportedBy = report.reportedBy
        self.suggestedTitle = report.suggestedTitle
        self.suggestedDescription = report.suggestedDescription
        self.reportState = report.reportState
        self.attachments = report.attachments
        self.cityId = report.cityId
        self.reportContainer = report.reportContainer
    }
    
    func toModel() -> Report {
        return Report(
            id: self.id,
            coordinate: self.coordinate,
            address: self.address,
            title: self.title,
            description: self.description,
            severityId: self.severityId,
            statusId: self.statusId,
            issueTypeId: self.issueTypeId,
            matterToSolveId: self.matterToSolveId,
            reportedAt: self.reportedAt,
            cellIndex: self.cellIndex,
            olc: self.olc,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            reportedBy: self.reportedBy,
            suggestedTitle: self.suggestedTitle,
            suggestedDescription: self.suggestedDescription,
            reportState: self.reportState,
            attachments: self.attachments,
            cityId: self.cityId,
            reportContainer: self.reportContainer
        )
    }
}

protocol ReportRepresentable {
    var issueType: IssueTypes { get set}
    var severity: Severity { get set }
    var status: IssueStatus { get set }
    var reportedDate: String { get }
    var createdAt: String { get }
    var updatedAt: String { get }
    
}

// MARK: - Extension to use related values of the enums
extension Report {
    
    /// Maps out the current report to be sent 
    func toDao() -> ReportDAO {
        ReportDAO(self)
    }
    
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
