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

final class ReportRepository {
    static let shared = ReportRepository()
    private let reportsService: ReportsService
    private init() {
        reportsService = ReportsService()
    }
    
    func list(onError: ErrorHandler) async -> [IssueMarker] {
        do {
            let reports: [Report] = try await self.reportsService.fetchReports()

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
                    matterToSolveId: report.matterToSolveId,
                    address: report.address
                )
            }
        } catch {
            onError(error)
            return []
        }
    }
    
    func listReports(onError: ErrorHandler) async -> [Report] {
        do {
            return try await self.reportsService.fetchReports()
        } catch {
            onError(error)
            return []
        }
    }
    
    func listByUser(page: Int, onComplete: @escaping (Reports) -> Void, onError: ErrorHandler) async {
        do {
            let result = try await self.reportsService.fetchReportByUser(
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
    
    func delete(_ reportId: String, onComplete: @escaping (GenericResponse) -> Void, onError: ErrorHandler) async {
        do {
            
            let result = try await self.reportsService.deleteReport(by: reportId)
            onComplete(result)
            
        } catch {
            onError(error)
        }
    }
    
    func create(report: Report, locator: Locator, onError: ErrorHandler) async  -> String {
        do {
            let response = try await self.reportsService.createReport(
                report: report,
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
    
    func update(report: Report,locator: Locator, onComplete: @escaping (GenericResponse) -> Void, onError: ErrorHandler) async {
        do {
            
            guard let id = report.id as String? else {
                onError(CustomError.missingId)
                return
            }
            
            if report.reportState == .modifying {
                let response = try await self.reportsService.updateReport(reportId: id, report: report, headers: [])
                onComplete(response)
            } else {
                onError(CustomError.missingId)
            }
            
        } catch {
            onError(error)
            
        }
    }
}


enum CustomError: Error {
    case missingId
    case invalidState
}
