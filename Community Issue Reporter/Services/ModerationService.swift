//
//  ModerationService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/8/26.
//

import Foundation

struct ModerationService {
    private let client: ServiceClient
    
    init(client: ServiceClient = ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func moderateReport(reason: ReportViolation<MapExplorerReport>, type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user-generated-content/moderation/\(type.rawValue)", body: reason, headers: headers, withOAuth: true)
    }
    
    func moderateContent(reason: ReportViolation<PreviewAttachment>, type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user-generated-content/moderation/\(type.rawValue)", body: reason, headers: headers, withOAuth: true)
    }
    
    func moderateComment(reason: ReportViolation<CommentToBlock>, type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user-generated-content/moderation/\(type.rawValue)", body: reason, headers: headers, withOAuth: true)
    }
    
    /// List request complaints that a user do agains a content or comment
    func myComplaints(headers: [HTTPHeader]) async throws -> PaginatedResponse<ReportViolation<ModeratedContent>> {
        return try await client.get(path: "user-generated-content/moderation/my-complaints", headers: headers, withOAuth: true)
    }
    
    /// citizen who received the moderation because of a content that is prohibed in our terms
    func indictedModeratedContent(type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> PaginatedResponse<ReportViolation<PreviewAttachment>> {
        return try await client.get(path: "user-generated-content/moderation/indicted/my-accusations/\(type.rawValue)", headers: headers, withOAuth: true)
    }
    
    /// citizen who received the moderation because of a messages are agains our terms
    func indictedModeratedMessages(type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> PaginatedResponse<ReportViolation<CommentToBlock>> {
        return try await client.get(path: "user-generated-content/moderation/indicted/my-accusations/\(type.rawValue)", headers: headers, withOAuth: true)
    }
    
    func indictedModeratedContent(headers: [HTTPHeader])async throws -> PaginatedResponse<ReportViolation<ModeratedContent>> {
        return try await client.get(path: "user-generated-content/moderation/indicted/my-accusations/all", headers: headers, withOAuth: true)
    }
    
    func appeal(id: String, type: TypeOfContentToReport, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.put(path: "user-generated-content/moderation/\(id)/appeal", body: [String: String](), headers: headers, withOAuth: true)
    }
}
