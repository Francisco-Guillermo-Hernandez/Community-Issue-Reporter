//
//  ReportRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation
import CoreLocation
import SwiftData

typealias ErrorHandler = @Sendable (Error) -> Void
typealias Reports = PaginatedResponse<Report>

final class ReportRepository {
    static let shared = ReportRepository()
    private let reportsService: ReportsService
    
    var headers: [HTTPHeader]
    private init() {
        reportsService = ReportsService()
        headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
        ]
    }
    

    func start() async throws -> StartReportResponse {
        do {
            return try await self.reportsService.start(headers: headers)
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
    
    func listByUser(page: Int) -> AsyncThrowingStream<PaginatedResponse<ReportDAO>, Error> {
        return AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let cachedResponse = await self.cachedReportsByUser(page: page)
                    if let cached = cachedResponse, !(cached.documents?.isEmpty ?? true) {
                        continuation.yield(cached)
                    }
                    
                    let freshResponse = try await self.reportsService.fetchReportByUser(
                        q: PaginatedRequestQueryParams(page: page, limit: 5)
                    )
                    
                    await self.saveReportsByUser(freshResponse, cachedResponse: cachedResponse, page: page)
                    
                    continuation.yield(freshResponse)
                    continuation.finish()
                } catch {
                    print(error)
                    continuation.finish(throwing: CommonIntercommunicationErrors.genericError(error.localizedDescription))
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    @MainActor
    private func cachedReportsByUser(page: Int) async -> PaginatedResponse<ReportDAO>? {
        guard let container = SwiftDataLocatorDAO.shared.container else { return nil }
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<MyReportDAOEntity>(
            predicate: #Predicate { $0.page == page }
        )
        
        do {
            let entities = try context.fetch(descriptor)
            if entities.isEmpty { return nil }
            let decoder = JSONDecoder()
            let documents = entities.compactMap { entity -> ReportDAO? in
                return try? decoder.decode(ReportDAO.self, from: entity.data)
            }
            let hasNext = entities.first?.hasNext ?? false
            return PaginatedResponse<ReportDAO>(
                documents: documents,
                total: nil,
                page: page,
                documentsPerPage: 5,
                totalPages: nil,
                hasNext: hasNext,
                hasPrev: page > 1
            )
        } catch {
            return nil
        }
    }
    
    @MainActor
    private func saveReportsByUser(
        _ freshResponse: PaginatedResponse<ReportDAO>,
        cachedResponse: PaginatedResponse<ReportDAO>?,
        page: Int
    ) async {
        guard let container = SwiftDataLocatorDAO.shared.container else { return }
        let context = container.mainContext
        let encoder = JSONEncoder()
        
        let freshDocuments = freshResponse.documents ?? []
        let freshIds = Set(freshDocuments.compactMap { $0.id })
        
        if let cachedDocuments = cachedResponse?.documents {
            for cached in cachedDocuments {
                guard let id = cached.id else { continue }
                if !freshIds.contains(id) {
                    if let entity = try? context.fetch(FetchDescriptor<MyReportDAOEntity>(predicate: #Predicate { $0.id == id })).first {
                        context.delete(entity)
                    }
                }
            }
        }
        
        let hasNext = freshResponse.hasNext
        for doc in freshDocuments {
            guard let id = doc.id, let data = try? encoder.encode(doc) else { continue }
            let entity = MyReportDAOEntity(id: id, page: page, data: data, hasNext: hasNext)
            context.insert(entity)
        }
        
        try? context.save()
    }
    
    func listByProfile(_ profileId: String) async throws -> [ReportDAO] {
        do {
           return try await self.reportsService.fetchReportsByProfile(id: profileId, headers: self.headers)
        } catch {
            print(error)
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
                    HTTPHeader(name: "GroupingCode", content: model.locator.groupingId)
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
    
    func update(_ report: Report) async throws -> SuccessfulResult {
        do {
            
            guard let id = report.id as String? else {
                
                throw CommonIntercommunicationErrors.genericError("No report id")
            }
            
            if report.reportState == .modifying {
                let response = try await self.reportsService.updateReport(reportId: id, report: report, headers: self.headers)
                
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

    func submitGroupedAttachments(attachments: [GroupedAttachmentPayload]) async throws -> CustomizedResponse<[ReportAttachmentGrouping]> {
        do {
            let response = try await self.reportsService.submitGroupedAttachments(
                attachments: attachments,
                headers: self.headers
            )
            
            if response.code == "ATTACHMENTS_SAVED" {
                return response
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
    
    func fetchResolutionByReport(_ reportId: String) async throws -> Resolution {
        do {
            return try await self.reportsService.fetchResolutionByReport(reportId: reportId, headers: self.headers)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            print(error)
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func haveReportBeenValidatedByMe(_ reportId: String) async throws -> Bool {
        if !reportId.isEmpty && reportId == "SV-SS-260601-aXWsaxls" {
            return true
        }
        
        return false
    }
    
    func boostReportValidation(_ reportId: String) async throws -> GenericResponse {
        do {
            return try await self.reportsService.boostReportValidation(reportId, headers: self.headers)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let error) {
            throw CommonIntercommunicationErrors.invalidPetition(error.message)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func fetchAttachments(_ reportId: String, page: Int) async throws -> PaginatedResponse<PreviewAttachment> {
        do {
            let query = PaginatedRequestQueryParams(page: page, limit: 12)
            return try await self.reportsService.fetchAttachments(of: reportId, query: query, headers: self.headers)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            print(error)
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
}


enum CustomError: Error {
    case missingId
    case invalidState
}
