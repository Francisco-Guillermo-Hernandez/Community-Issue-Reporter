//
//  CityService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/5/26.
//

import Foundation

struct CityService {
    
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: development)) {
        self.client = client
    }
    
    func filter(q: PaginatedRequestQueryParams) async throws -> FriendlyCities {
        return try await client.get(path: "cities/filter", query: q, headers: [], withOAuth: false)
    }
}
