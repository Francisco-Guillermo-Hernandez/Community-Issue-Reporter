//
//  ReportDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import Foundation
import SwiftUI

@Observable
final class ReportDataModel {
    
    var report: Report
    var locator: Locator
    init() {
        self.report = Report(
            coordinate: Coordinate(lat: 0.0, lng: 0.0),
            address: "",
            title: "",
            description: "",
            severityId: 1,
            statusId: 1,
            issueTypeId: 1,
            matterToSolveId: 1,
            cellIndex: "",
            createdAt: Date(),
            updatedAt: Date(),
            reportState: .new,
        )
        
        self.locator = Locator(id: "", countryCode: "", country: "", region: "", city: "", address: "")
    }
    
    func setMatterToSolve(_ matter: MatterToSolve) {
        report.matterToSolveId = matter.id
        report.severityId = matter.severity.identifier
        report.issueTypeId = matter.issueType.identifier
        report.suggestedTitle = matter.title
        report.suggestedDescription = matter.description
    }
    
    func updateCoordinate(_ coordinate: Coordinate) {
        report.coordinate = coordinate
    }
    
    func updateLocator(_ locator: Locator) {
        self.locator = locator
        self.report.address = locator.address
    }
    
    func prepareForModification(_ report: Report) {
        self.report = report
        self.report.reportState = .modifying
    }
}
