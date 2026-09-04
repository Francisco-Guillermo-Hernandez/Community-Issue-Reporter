//
//  CounterService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/9/26.
//

import Foundation

struct CounterService {
    
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func increase(_ headers: [HTTPHeader]) async throws -> CustomizedResponse<ReportCounter> {
        return try await self.client.post(path: "report-counter/increase", body: [String: String](),  withOAuth: true)
    }
    
    func count(_ headers: [HTTPHeader]) async throws -> CustomizedResponse<ReportCounter> {
        return try await self.client.get(path: "report-counter", withOAuth: true)
    }
}
