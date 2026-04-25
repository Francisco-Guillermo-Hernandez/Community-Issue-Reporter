//
//  Requests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import Foundation

struct OAuthSignInPayload: Encodable {
    let token: String
}

struct PaginatedRequestQueryParams: Encodable {
    let page: Int?
    let limit: Int?
    
    init(page: Int? = 1, limit: Int? = 3) {
        self.page = page
        self.limit = limit
    }
}
