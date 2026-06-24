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
   
    static let shared = ReportDataModel()
    var report: Report
    var locator: Locator
    private let settings = SettingsStore.shared
   
    var isAddressValid: Bool = false
    var reportSession: ReportSessionResponse
    private init() {
        self.reportSession = .init(reportContainer: "", createdAt: Date(), shareIndexHash: "", reportCreationOn: "")
        
        /// Let's initialize the locator for the report
        self.locator = Locator(
            countryCode: "SV",
            country: "El Salvador",
            region: "San Salvador",
            city: "San Salvador",
            cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
            cityNameSortKey: "san-salvador",
            cityCode: "SS",
            address: "Paseo General Escalón &, Alameda Franklin Delano Roosevelt, San Salvador"
        )
        
        let appState = AuthViewModel()
        var lat: Double =  13.7159815
        var lng: Double = -89.1801214
    
        /// lets get the coordinates that were set at the landing process or settings view
        if let selectedCity = appState.selectedCity {
            lat = selectedCity.coordinates.lat
            lng = selectedCity.coordinates.lng
        }

        /// Initialize the report template with some basic information
        self.report = Report(
            coordinate: .init(lat, lng),
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
    }
    
    func setMatterToSolve(_ matter: MatterToSolve) {
        report.matterToSolveId = matter.id
        report.severityId = matter.severity.identifier
        report.issueTypeId = matter.issueType.identifier
        report.title = matter.title
        report.description = matter.description
        report.suggestedTitle = matter.title
        report.suggestedDescription = matter.description
    }
    
    func updateReportSession(_ reportSession: ReportSessionResponse) {
        self.reportSession = reportSession
    }
    
    func updateCoordinate(_ coordinate: Coordinate) {
        report.coordinate = coordinate
    }
    
    func updateLocator(with locator: Locator) {
        self.locator = locator
        self.report.address = self.locator.address
    }
    
    func prepareForModification(_ report: Report) {
        self.report = report
        self.report.reportState = .modifying
    }
    
    func clear() {
        self.report = Report(
            coordinate: .init(lat: 13.68935, lng: -89.18718),
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
    }
    
    func buildReportId() -> String {
        return "\(locator.countryCode)-\(locator.cityCode)-\(self.reportSession.reportCreationOn)-\(self.reportSession.shareIndexHash)"
    }
}
