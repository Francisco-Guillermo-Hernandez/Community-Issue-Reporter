//
//  VotingRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/8/26.
//

import Foundation

final class VotingRepository {
    
    static let shared: VotingRepository = .init()
    
    var service: VotingService
    var headers: [HTTPHeader]
    private init() {
        self.service = VotingService()
        headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
        ]
    }
    
    func vote(type: VotingType, payload: Voting) async throws -> SuccessfulResult {
        do {
            let result = try await self.service.vote(for: type, payload: payload, headers: headers)
            if result.code == "OK" {
                return .done
            } else {
                throw CommonIntercommunicationErrors.unProcessable
            }
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let error) {
            throw CommonIntercommunicationErrors.invalidPetition(error.message)
        }  catch ServiceError.unProcessable {
            throw CommonIntercommunicationErrors.unProcessable
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func havIVoted(type: VotingType, resourceId: String) async throws -> VotingResolution {
        do {
            let result = try await self.service.havIVoted(for: type, resourceId: resourceId, headers: headers)
            return result.data
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let error) {
            throw CommonIntercommunicationErrors.invalidPetition(error.message)
        }  catch ServiceError.unProcessable {
            throw CommonIntercommunicationErrors.unProcessable
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
}
