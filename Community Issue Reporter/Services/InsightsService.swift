//
//  InsightsService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/7/26.
//

import Foundation

struct InsightsService {
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func getMonthlyInsights(_ filter: InsightsFilter) async throws -> MonthlyInsightsResponse {
        return try await self.client.get(path: "insights/stats/\(filter.year)/\(filter.month)", withOAuth: true)
    }
}
