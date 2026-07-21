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
    var isTitleValid: Bool = false
    var isDescriptionValid: Bool = false
    var reportSession: ReportSessionResponse
    var isDifferentLocation: Bool = false
    var titlePlaceholder: String = "e.g. Street Repair"
    var descriptionPlaceholder: String = "e.g. Street is blocked"
    private init() {
        self.reportSession = .init(
            reportContainer: "", 
            createdAt: Date(),
            shareIndexHash: "",
            reportCreationOn: ""
        )
    
        
        let appState = AuthViewModel()
        var lat: Double =  13.7159815
        var lng: Double = -89.1801214
    
        
        /// Let's initialize the locator for the report
        self.locator = .init(
            countryCode: "SV",
            firstLevel: "El Salvador",
            secondLevel: "San Salvador",
            thirdLevel: "San Salvador",
            groupingId: "f30b2834-12ee-4b0c-85eb-660ee7b08ed4",
            cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
            groupingName: "Municipio de San Salvador Centro",
            groupingNameCode: "SSC",
            lat: lat,
            lng: lng,
            geoCode: "0614",
            zipCode: "1101",
            isCapitalCityRaw: 1,
            isDepartmentalCapitalRaw: 1,
            cityNameSortKey: "san-salvador",
            address: "Paseo General Escalón &, Alameda Franklin Delano Roosevelt, San Salvador"
        )
    
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
            attachments: [],
        )
    }
    
    func setMatterToSolve(_ matter: MatterToSolve) {
        report.matterToSolveId = matter.id
        report.severityId = matter.severity.identifier
        report.issueTypeId = matter.issueType.identifier
        titlePlaceholder = matter.title
        descriptionPlaceholder = matter.description
        report.suggestedTitle = matter.title
        report.suggestedDescription = matter.description
    }
    
    func setLocator(countryCode: String, cityId: String) {
        self.locator = LocatorDAO.shared.findBy(countryCode: countryCode, cityId: cityId)
    }
    
    func getMetadataFromReportId(_ reportId: String, _ reportContainer: String) -> (String, ReportSessionResponse) {

        /// SV-SSC-20260715-e5v2TpcbuyvaRLY0
        /// country [0]
        /// grouping [1]
        /// reportCreationOn [2]
        /// shareIndexHash [3]
        let parts = reportId.split(separator: "-")
        
        return (
            String(parts[0]),
            .init(
                reportContainer: reportContainer,
                createdAt: Date(),
                shareIndexHash: String(parts[3]),
                reportCreationOn: String(parts[2])
            )
        )
    }
    
    ///
    func updateReportSession(_ reportSession: ReportSessionResponse) {
        self.reportSession = reportSession
        self.report.reportContainer = reportSession.reportContainer
    }
    
    ///
    func updateCoordinate(_ coordinate: Coordinate) {
        report.coordinate = coordinate
    }
    
    ///
    func updateLocator(with locator: Locator) {
        self.locator = locator
        self.report.address = self.locator.address
    }
    
    /// Set report for modifying state
    func prepareForModification(_ report: Report) {
        self.report = report
        self.report.reportState = .modifying
    }
    
    /// Maps out PhotoUploadTracker to PreviewAttachmentRequest to add those attachments into report attachment
    func addAttachments(_ attachments: [PhotoUploadTracker]) {
        if self.report.reportState == .modifying {
            let existingKeys = Set(attachments.filter { $0.isExisting }.map { $0.key })
            self.report.attachments.removeAll { !existingKeys.contains($0.key) }
        }
        
        let newAttachments = attachments.filter { !$0.isExisting }
        let payload = newAttachments.map { attachment in
            PreviewAttachmentRequest(
                fileName: attachment.name,
                type: .image,
                key: attachment.key,
                notes: "",
                reportContainer: self.report.reportContainer ?? "",
            )
        }
        
        self.report.attachments.append(contentsOf: payload)
    }
    
    /// Maps incoming PreviewAttachmentRequest array to PhotoUploadTracker array
    func mapAttachmentsToTrackers(_ attachments: [PreviewAttachmentRequest]) -> [PhotoUploadTracker] {
        return attachments.map { attachment in
            PhotoUploadTracker(
                key: attachment.key,
                name: attachment.fileName,
                url: attachment.url,
                isExisting: true
            )
        }
    }
    
    /// Maps current report's PreviewAttachmentRequest attachments to PhotoUploadTracker array
    func getAttachmentsAsTrackers() -> [PhotoUploadTracker] {
        return mapAttachmentsToTrackers(self.report.attachments)
    }
    
    func removeAttachments() {
        self.report.attachments.removeAll()
    }
    
    func clear() -> Void {
        
        let appState = AuthViewModel()
        var lat: Double =  13.7159815
        var lng: Double = -89.1801214

        if let selectedCity = appState.selectedCity {
            lat = selectedCity.coordinates.lat
            lng = selectedCity.coordinates.lng
        }
        
        self.isAddressValid = false
        self.isDifferentLocation = false
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
    
    func buildReportId() -> String {
        return "\(locator.countryCode)-\(locator.groupingNameCode)-\(self.reportSession.reportCreationOn)-\(self.reportSession.shareIndexHash)"
    }
}
