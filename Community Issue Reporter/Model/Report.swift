//
//  Report.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
//

import Foundation

struct Report: Identifiable, Codable {
    let id: String?
    let coordinate: Coordinate
    let address: String
    let title: String
    let description: String
    let severityId: Int
    let statusId: Int
    let issueTypeId: Int
    let matterToSolveId: Int
    let reportedAt: Date?
    let cellIndex: String
    let createdAt: Date?
    let updatedAt: Date?
    let reportedBy: String?
    let olc: String?
    
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
        }
}

extension Report {
    var issueType: IssueTypes {
        IssueTypes.allCases.first(where: { $0.identifier == self.issueTypeId }) ?? .all
    }
    
    var severity: Severity {
        Severity.allCases.first(where: { $0.identifier == self.severityId }) ?? .low
    }

    var status: IssueStatus {
        IssueStatus.allCases.first(where: { $0.identifier == self.statusId }) ?? .reported
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
