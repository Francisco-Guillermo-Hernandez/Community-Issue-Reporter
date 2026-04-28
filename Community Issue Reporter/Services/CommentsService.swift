//
//  CommentsService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/4/26.
//

import Foundation

struct CommentsService {
    
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: commentService)) {
        self.client = client
    }
    
    func post(comment: CommentRequest, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.post(path: "comments/", body: comment, headers: headers, withOAuth: true)
    }
    
    func update(comment: Comment) async throws -> GenericResponse {
        return try await client.put(path: "comments/\(comment.id)", body: comment, withOAuth: true)
    }
    
    func delete(id: String) async throws -> GenericResponse {
        return try await client.delete(path: "comments/\(id)", body: [String: String](), withOAuth: true)
    }
    
    /// list all the comments that the user has post
    func listByUser(q: PaginatedRequestQueryParams) async throws -> PaginatedResponse<Comment> {
        return try await client.get(path: "comments/user", query: q, headers: [], withOAuth: true)
    }
    
    /// Comments by report
    func list(reportId: String, q: PaginatedRequestQueryParams) async throws -> PaginatedResponse<Comment> {
        return try await client.get(path: "comments/report/\(reportId)", query: q, headers: [], withOAuth: true)
    }
}
