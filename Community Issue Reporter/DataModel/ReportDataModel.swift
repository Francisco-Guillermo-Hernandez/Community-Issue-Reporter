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
    
    private init() {
        self.locator = Locator(id: "", countryCode: "", country: "", region: "", city: "", address: "")
        
//        var coordinate = Coordinate(lat: 0.0, lng: 0.0)
//        if let country = settings.country {
//            
//            
////            if let region = country.regions[0] {
////                if let city = region.cities[0] {
////                    coordinate = Coordinate(lat: city.coordinates.lat, lng: city.coordinates.lng )
////                }
////            }
//           
//        }
        
        self.report = Report(
            coordinate: .init(lat: 14.493928750122384, lng:-88.9194851492362), //.init(lat: 13.68935, lng: -89.18718),
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
        
        
        print("selected country")
        print(settings.country?.name ?? "no country")
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
    
    func updateLocator(with locator: Locator) {
        self.locator = locator
        self.report.address = self.locator.address
    }
    
    func prepareForModification(_ report: Report) {
        self.report = report
        self.report.reportState = .modifying
        
        dump(self.report)
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
}
