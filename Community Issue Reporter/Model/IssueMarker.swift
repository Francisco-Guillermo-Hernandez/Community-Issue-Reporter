//
//  IssueMarker.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/4/26.
//

import Foundation
import CoreLocation

struct IssueMarker: Identifiable {
    let id: String
    let title: String
    let description: String
    let status: IssueStatus
    let coordinate: CLLocationCoordinate2D
    let issueType: IssueTypes
    let severity: Severity
    let matterToSolve: MatterToSolve
    let address: String
    
    init(id: String,
         title: String,
         description: String,
         status: Int,
         coordinate: CLLocationCoordinate2D,
         issueType: Int,
         severity: Int,
         matterToSolveId: Int,
         address: String) {
        
        self.id = id
        self.title = title
        self.description = description
        self.status = IssueStatus.allCases[status]
        self.coordinate = coordinate
        self.issueType = IssueTypes.allCases[issueType]
        self.severity = Severity.allCases[severity]
        self.matterToSolve = mattersToResolve.first(where: { $0.id == matterToSolveId }) ?? mattersToResolve[0]
        self.address = address
    }
}

