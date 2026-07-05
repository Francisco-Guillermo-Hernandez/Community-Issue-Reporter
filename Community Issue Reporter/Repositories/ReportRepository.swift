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
    

    func start() async throws -> StartReportResponse {
        do {
            return try await self.reportsService.start(
                headers: [
                    HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                    HTTPHeader(name: "CountryCode", content: "SV"),
                ]
            )
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func deleteTemporalPicture(_ reportContainer: String, _ key: String) async throws -> SuccessfulResult {
        do {
            let result = try await self.reportsService.deleteTemporalPicture(key, headers: [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
                HTTPHeader(name: "Report-Container", content: reportContainer),
            ])
            
            if result.code == "MEDIA_DELETED_SUCCESSFULLY" {
                return .deleted
            } else {
                throw CommonIntercommunicationErrors.genericError(result.message)
            }
        } catch {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        }
    }
    
    func listReports(onError: ErrorHandler) async throws -> [Report] {
        do {
            return try await self.reportsService.fetchReports()
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func listByUser(page: Int) async throws -> Reports {
        do {
            let result = try await self.reportsService.fetchReportByUser(
                q: PaginatedRequestQueryParams(
                    page: page,
                    limit: 5
                )
            )
            
           return result
    
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func delete(_ reportId: String) async throws -> SuccessfulResult {
        do {
            
            let result = try await self.reportsService.deleteReport(by: reportId)
            if result.code == "REPORT_DELETED_SUCCESSFULLY" {
               return .deleted
            } else {
                throw CommonIntercommunicationErrors.genericError("Error deleting report")
            }
            
        } catch {
           throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Creates a new report using model
    func create(using model: ReportDataModel) async throws -> String {
        do {
            let response = try await self.reportsService.createReport(
                report: model.report,
                headers: [
                    HTTPHeader(name: "CountryCode", content: model.locator.countryCode),
                    HTTPHeader(name: "CityId", content: model.locator.cityId),
                    HTTPHeader(name: "ShareIndexHash", content: model.reportSession.shareIndexHash),
                    HTTPHeader(name: "ReportContainer", content: model.reportSession.reportContainer),
                    HTTPHeader(name: "GroupingNameCode", content: model.locator.groupingNameCode),
                ]
            )
            
            if response.code == "REPORT_CREATED" {
                return response.id
            } else {
                throw CommonIntercommunicationErrors.genericError("Error creating report")
            }
            
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func update(report: Report, locator: Locator) async throws -> SuccessfulResult {
        do {
            
            guard let id = report.id as String? else {
                
                throw CommonIntercommunicationErrors.genericError("No report id")
            }
            
            if report.reportState == .modifying {
                let response = try await self.reportsService.updateReport(reportId: id, report: report, headers: [])
                
                if response.code == "REPORT_UPDATED" {
                    return .updated
                } else {
                    throw CommonIntercommunicationErrors.genericError("Error updating report")
                }
                
            } else {
                throw CommonIntercommunicationErrors.genericError("Error updating report")
            }
            
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
            
        }
    }

    func submitGroupedAttachments(attachments: [GroupedAttachmentPayload]) async throws -> SuccessfulResult {
        do {
            let response = try await self.reportsService.submitGroupedAttachments(
                attachments: attachments,
                headers: [
                    HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                    HTTPHeader(name: "CountryCode", content: "SV"),
                ]
            )
            
            if response.code == "ATTACHMENTS_SAVED" {
                return .created
            } else {
                throw CommonIntercommunicationErrors.genericError("Error submitting report attachments")
            }
            
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
}


enum CustomError: Error {
    case missingId
    case invalidState
}
