//
//  ReportRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation
import CoreLocation

typealias ErrorHandler = @Sendable (Error) -> Void
typealias Reports = PaginatedResponse<Report>

struct ReportRepository {
    static func list(onError: ErrorHandler) async -> [IssueMarker] {
        do {
            let reports: [Report] = try await ReportsService().fetchReports()

            return reports.compactMap { report in
                return IssueMarker(
                    id: report.id!,
                    title: report.title,
                    description: report.description,
                    status: report.statusId,
                    coordinate:  CLLocationCoordinate2D(
                        latitude: report.coordinate.lat,
                        longitude: report.coordinate.lng
                    ),
                    issueType: report.issueTypeId,
                    severity: report.severityId,
                    matterToSolve: report.matterToSolveId,
                    address: report.address
                )
            }
        } catch {
            onError(error)
            return []
        }
    }
    
    static func listReports(onError: ErrorHandler) async -> [Report] {
        do {
            return try await ReportsService().fetchReports()
        } catch {
            onError(error)
            return []
        }
    }
    
    static func listByUser(page: Int, onComplete: @escaping (Reports) -> Void, onError: ErrorHandler) async {
        do {
            let result = try await ReportsService().fetchReportByUser(
                    q: PaginatedRequestQueryParams(
                        page: page,
                        limit: 16
                    )
                )
            onComplete(result)
        } catch {
            onError(error)
        }
    }
    
    static func delete(_ reportId: String, onComplete: @escaping (GenericResponse) -> Void, onError: ErrorHandler) async {
        do {
            
           let result = try await ReportsService().deleteReport(by: reportId)
            onComplete(result)
            
        } catch {
            onError(error)
        }
    }
    
    static func create(report: Report, locator: Locator, onError: ErrorHandler) async  -> String {
        do {
            let response = try await ReportsService().createReport(
                report: Report(
                    coordinate: report.coordinate,
                    address: report.address,
                    title: report.title,
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
            onError(error)
            return "-1"
        }
    }
}
