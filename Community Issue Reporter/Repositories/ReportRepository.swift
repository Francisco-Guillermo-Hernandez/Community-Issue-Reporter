//
//  ReportRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation
import CoreLocation

struct ReportRepository {
    static func list() async -> [IssueMarker] {
        do {
            let reports: [Report] = try await ReportsService().fetchReports()

            return reports.compactMap { report in
                return IssueMarker(
                    title: report.description,
                    status: .inProgress,
                    coordinate: CLLocationCoordinate2D(
                        latitude: report.coordinate.lat,
                        longitude: report.coordinate.lng
                    ),
                    issueType: .road
                )
            }
        } catch {
            return []
        }
    }
    
    static func listReports() async -> [Report] {
        do {
            return try await ReportsService().fetchReports()
        } catch {
            return []
        }
    }
    
    static func create(report: Report, locator: Locator) async  -> String {
        do {
            let response = try await ReportsService().createReport(
                report: Report(
                    coordinate: report.coordinate,
                    address: report.address,
                    description: report.description,
                    severityId: report.severityId,
                    statusId: report.statusId,
                    issueTypeId: report.issueTypeId,
                    matterToSolveId: report.matterToSolveId,
                    cellIndex: report.cellIndex,
                ),
                headers: [
                    HTTPHeader(name: "Country", content: locator.country),
                    HTTPHeader(name: "Region", content: locator.region),
                    HTTPHeader(name: "City", content: locator.city),
                ]
            )
            return response.id
        } catch {
            print(error)
            return "-1"
        }
    }
}
