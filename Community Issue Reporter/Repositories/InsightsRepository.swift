//
//  InsightsRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/7/26.
//

import Foundation

final class InsightsRepository {
    
    static let shared = InsightsRepository()
    let service: InsightsService
    private init() {
        self.service = InsightsService()
    }
    
    func insightsForThisMonth() async throws -> MonthlyInsightsResponse {
        let filter = InsightsFilter(year: getFullYear(), month: getMonthName())
        return try await service.getMonthlyInsights(filter)
    }
    
    func filterInsights(by filter: InsightsFilter) async throws -> MonthlyInsightsResponse {
        return try await service.getMonthlyInsights(filter)
    }
}
