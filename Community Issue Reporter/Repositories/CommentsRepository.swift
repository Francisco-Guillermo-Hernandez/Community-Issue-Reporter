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
    
    func list(_ reportId: String, page: Int, limit: Int = 3, onError: ErrorHandler) async -> Comments  {
      
        do {
            let query = PaginatedRequestQueryParams(page: page, limit: limit)
            return try await self.commentsService.list(reportId: reportId, q: query)
        } catch {
            onError(error)
            return Comments(documents: [], hasNext: false, hasPrev: false)
        }
    }
    
    func listByUser(page: Int, onComplete: @escaping (Comments) -> Void, onError: ErrorHandler) async {
        do {
            let result = try await self.commentsService.listByUser(q: PaginatedRequestQueryParams(page: page, limit: 20))
            onComplete(result)
           
        } catch {
            onError(error)
        }
    }
    
    func post(_ comment: Comment, onComplete: @escaping () -> Void, onError: ErrorHandler) async {
        do {
            let headers: Array<HTTPHeader> = [
                HTTPHeader(name: "country", content: "country"),
                HTTPHeader(name: "City", content: "city"),
            ]
            let result = try await self.commentsService.post(comment: comment, headers: headers)
            
            if result.code == "COMMENT_CREATED" {
                onComplete()
            }
            
           
        } catch {
            onError(error)
        }
    }
    
    func update(_ comment: Comment, onComplete: @escaping () -> Void, onError: ErrorHandler) async {
        do {
            _ = try await self.commentsService.update(comment: comment)
            onComplete()
        } catch {
            onError(error)
        }
    }
    
    //
    func delete(_ id: String, onComplete: @escaping () -> Void, onError: ErrorHandler) async {
        do {
            _ = try await self.commentsService.delete(id: id)
            onComplete()
        } catch {
            onError(error)
        }
    }
}
