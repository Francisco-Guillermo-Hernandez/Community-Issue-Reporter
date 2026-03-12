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
            let reports = try await ReportsService().fetchReports()

            return reports.compactMap { report in
                guard let latitude = report.latitude,
                      let longitude = report.longitude else {
                    return nil
                }

                return IssueMarker(
                    title: report.description,
                    status: .inProgress,
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    issueType: .road
                )
            }
        } catch {
            return []
        }
    }
    
    static func create(report: Report) async  -> String {
        do {
            let response = try await ReportsService().createReport(
                report: Report(
                    id: nil,
                    coordinate: [
                        String(report.latitude ?? 0),
                        String(report.longitude ?? 0)
                    ],
                    address: report.address,
                    description: report.description,
                    severityId: 1,
                    statusId: 1,
                    issueTypeId: 1,
                    matterToSolveId: 1,
                    reportedAt: nil,
                    cellIndex: "0",
                    createdAt: nil,
                    updatedAt: nil,
                    reportedBy: ""
                )
            )
            
            print(response)
            
            return response.id
        } catch {
            return ""
        }
    }
}
