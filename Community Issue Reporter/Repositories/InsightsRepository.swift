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
    
    func initialize() async throws -> SuccessfulResult {
        do {
            let response = try await service.initialize()
            if response.code == "USER_INSIGHTS_INITIALIZED" {
                return .created
            } else {
                throw CommonIntercommunicationErrors.invalidPetition(response.message)
            }
        } catch ServiceError.badRequest(let error) {
            throw CommonIntercommunicationErrors.invalidPetition(error.message)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func insightsForThisMonth() async throws -> MonthlyInsightsResponse {
        do {
            let filter = InsightsFilter(year: getFullYear(), month: getMonthName())
            return try await service.getMonthlyInsights(filter)
        } catch ServiceError.badRequest(let error) {
            throw CommonIntercommunicationErrors.invalidPetition(error.message)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func filterInsights(by filter: InsightsFilter) async throws -> MonthlyInsightsResponse {
        return try await service.getMonthlyInsights(filter)
    }
}
