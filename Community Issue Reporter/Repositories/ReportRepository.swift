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
}
