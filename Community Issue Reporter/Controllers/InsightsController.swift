//
//  InsightsController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/7/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class InsightsController {
    
    var navigationPath: [InsightsNavigation] = []
    private(set) var insights: MonthlyInsightsResponse = .init(totalReports: 0, totalSignatures: 0, totalComments: 0, totalPetitions: 0, recentActivity: [:])
    private(set) var isLoading: Bool = false
    private(set) var message: String = ""
    private(set) var showAlert: Bool = false
    
    func getInsights() async {
        do {
            let response = try await InsightsRepository.shared.insightsForThisMonth()
           insights = response
        } catch {
            print(error)
        }
    }
}
