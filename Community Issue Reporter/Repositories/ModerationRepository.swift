//
//  ModerationRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez.
//

import Foundation

final class ModerationRepository {
    
    static let shared: ModerationRepository = .init()
    private var service: ModerationService
    var headers: [HTTPHeader]
    private init () {
        self.service = .init()
        self.headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
            HTTPHeader(name: "CityId", content: "san-salvador")
        ]
    }
    
    func myComplaints() async throws -> PaginatedResponse<ReportViolation<ModeratedContent>> {
        do {
            return try await service.myComplaints(headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            print(error)
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func indictedModeratedContent(type: TypeOfContentToReport) async throws -> PaginatedResponse<ReportViolation<PreviewAttachment>> {
        do {
            return try await service.indictedModeratedContent(type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func indictedModeratedMessages(type: TypeOfContentToReport) async throws -> PaginatedResponse<ReportViolation<CommentToBlock>> {
        do {
            return try await service.indictedModeratedMessages(type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func moderateContent(reason: ReportViolation<PreviewAttachment>, type: TypeOfContentToReport) async throws -> GenericResponse {
        do {
            return try await service.moderateContent(reason: reason, type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func moderateComment(reason: ReportViolation<CommentToBlock>, type: TypeOfContentToReport) async throws -> GenericResponse {
        do {
            return try await service.moderateComment(reason: reason, type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }

    func appeal(id: String, type: TypeOfContentToReport) async throws -> GenericResponse {
        do {
            return try await service.appeal(id: id, type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func indictedModeratedContent() async throws -> PaginatedResponse<ReportViolation<ModeratedContent>> {
        do {
            return try await service.indictedModeratedContent(headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func moderateReport(reason: ReportViolation<MapExplorerReport>, type: TypeOfContentToReport) async throws -> GenericResponse {
        do {
            return try await service.moderateReport(reason: reason, type: type, headers: self.headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
}
