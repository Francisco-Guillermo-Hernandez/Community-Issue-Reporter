//
//  MapExplorerReportModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation
import CoreLocation

let miliSeconds: Double = 1000

struct MapExplorerReport: Identifiable, Decodable, Hashable {
    let id: String
    let lat: Double
    let lng: Double
    let address: String
    let title: String
    let description: String
    let severityId: Int
    let statusId: Int
    let issueTypeId: Int
    let matterToSolveId: Int
    let reportedAtRaw: Int64?
    let cellIndex: String
    let createdAtRaw: Int64
    let updatedAtRaw: Int64
    let reportedBy: String
    let cityId: String
    let petitionId: String?
    let shareUrl: String
    let attachments: [PreviewAttachment]
    let assignedTo: String?
    let reportContainer: String
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var createdAt: Date { Date(timeIntervalSince1970: Double(createdAtRaw) / miliSeconds) }
    var updatedAt: Date { Date(timeIntervalSince1970: Double(updatedAtRaw) / miliSeconds) }
    var reportedAt: Date? {
        get {
            if let reportedAtRaw {
               return Date(timeIntervalSince1970: Double(reportedAtRaw) / miliSeconds)
            }
            
            return nil
        }
    }
}

// MARK:  - Extensions

/// Let's make it conform to Equatable
extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

/// Extension to read the properties
extension MapExplorerReport {
    var issueType: IssueTypes {
        get {
            IssueTypes.allCases.first(where: { $0.identifier == self.issueTypeId }) ?? .all
        }
    }
    
    
    var severity: Severity {
          get {
              Severity.allCases.first(where: { $0.identifier == self.severityId }) ?? .low
          }
    }

    var status: IssueStatus {
        get {
            IssueStatus.allCases.first(where: { $0.identifier == self.statusId }) ?? .reported
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
        formatRelativeDate(from: self.createdAt)
    }
    
    var updatedDate: String {
        formatRelativeDate(from: self.updatedAt)
    }
    
    var assignedInstitution: String {
        if let assignedTo {
            return assignedTo
        } else {
            return String(localized: "Not assigned yet.")
        }
    }
}
