//
//  CommentsRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/4/26.
//

import Foundation

typealias Comments = PaginatedResponse<Comment>

final class CommentsRepository {
    
    static let shared = CommentsRepository()
    private let commentsService: CommentsService
    private init() {
        self.commentsService = CommentsService()
    }
    
    func list(_ reportId: String, page: Int, limit: Int = 3) async throws -> Comments  {
        
        do {
            let query = PaginatedRequestQueryParams(page: page, limit: limit)
            return try await self.commentsService.list(reportId: reportId, q: query)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.genericError("Unauthorized")
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func listByUser(page: Int) async throws -> Comments {
        do {
            return try await self.commentsService.listByUser(q: PaginatedRequestQueryParams(page: page, limit: 20))
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.genericError("Unauthorized")
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func post(_ comment: Comment) async throws -> SuccessfulResult {
        do {
            let headers: Array<HTTPHeader> = [
                HTTPHeader(name: "country", content: "country"),
                HTTPHeader(name: "City", content: "city"),
            ]
            let result = try await self.commentsService.post(comment: comment, headers: headers)
            
            if result.code == "COMMENT_CREATED" {
                return .done
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
            
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func update(_ comment: Comment) async throws -> SuccessfulResult {
        do {
            let result = try await self.commentsService.update(comment: comment)
            if result.code == "COMMENT_UPDATED" {
                return .updated
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Delete a comment of a user using it's ID
    func delete(_ id: String) async throws -> SuccessfulResult {
        do {
            let result = try await self.commentsService.delete(id: id)
            if result.code == "COMMENT_DELETED" {
                return .deleted
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
}
