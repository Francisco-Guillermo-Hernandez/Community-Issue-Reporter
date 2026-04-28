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
    var issueTypeId: Int?
    var severityId: Int?
    var ordering: String
    
    init(page: Int? = 1, limit: Int? = 3, issueTypeId: Int? = nil, severityId: Int? = nil, ordering: OrderFilter = .descending) {
        self.page = page
        self.limit = limit
        self.issueTypeId = issueTypeId
        self.severityId = severityId
        self.ordering = ordering.filter
    }
}

struct LocatorHeaders {
    let headers: Array<HTTPHeader>
}
