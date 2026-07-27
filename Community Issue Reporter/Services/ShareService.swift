//
//  ShareService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/6/26.
//

import Foundation

struct ShareService {
    
    private let client: ServiceClient
    init(client: ServiceClient = ServiceClient(baseURL: Endpoints.shareableURL)) {
        self.client = client
    }
    
    func createLink<R: Codable>(for share: Share<R>, headers: [HTTPHeader]) async throws -> CustomizedResponse<ShareUrlResponse> {
        try await client.post(path: "actions/create/shareable/link", body: share, headers: headers, withOAuth: true)
    }
}
