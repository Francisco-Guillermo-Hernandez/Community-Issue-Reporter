//
//  Responses.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/3/26.
//

import Foundation


struct GenericResponse: Identifiable, Codable {
    var id: String
    var message: String
    var code: String
}

struct UserTokens: Decodable {
    let queryActionsToken: String
    let mutationActionsToken: String
}

struct LoginWithOAuthProviderResponse: Decodable {
    var code: String
    var authToken: UserTokens
    var authProvider: String
}

struct PaginatedResponse<T: Decodable>: Decodable {
    let documents: [T]?
    let total: Int?
    let page: Int?
    let documentsPerPage: Int?
    let totalPages: Int?
    let hasNext: Bool
    let hasPrev: Bool
    
    init(
        documents: [T]? = [],
        total: Int? = nil,
        page: Int? = nil,
        documentsPerPage: Int? = nil,
        totalPages: Int? = nil,
        hasNext: Bool = false,
        hasPrev: Bool = false
    ) {
        self.documents = documents
        self.total = total
        self.page = page
        self.documentsPerPage = documentsPerPage
        self.totalPages = totalPages
        self.hasNext = hasNext
        self.hasPrev = hasPrev
    }
}
