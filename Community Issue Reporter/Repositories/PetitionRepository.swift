//
//  PetitionRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

final class PetitionRepository {

    static let share = PetitionRepository()
    private let service: PetitionsService
    private init() {
        self.service = PetitionsService()
    }

    func list(q: PaginatedRequestQueryParams, locator: Locator) async throws -> PaginatedResponse<PetitionPost> {
        do {

            return try await self.service.fetchPetitions(q, LocatorHeaders(headers: [
                HTTPHeader(name: "CountryCode", content: locator.countryCode),
                HTTPHeader(name: "SecondLevel", content: locator.secondLevel),
                HTTPHeader(name: "ThirdLevel", content: locator.thirdLevel),
            ]))
            
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }

    func create(_ petition: Petition) async throws -> SuccessfulResult {
        do {
            let result = try await self.service.createPetition(
                petition: petition
            )
           
            if result.code == "PETITION_CREATED" {
                return .created
            } else {
                throw CommonIntercommunicationErrors.genericError(result.message)
            }
            
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func update(
        petition: Petition,
        onComplete: @escaping (GenericResponse) -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        do {
            guard let id = petition.id else { return }
            let result = try await self.service.updatePetition(
                id: id,
                petition: petition
            )
            onComplete(result)
        } catch {
            onError(error)
        }
    }

    func listByUser(
        q: PaginatedRequestQueryParams,
        onComplete: @escaping (PaginatedResponse<Petition>) -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        do {
            let result = try await self.service.fetchPetitionsByUser(q)
            onComplete(result)
        } catch {
            onError(error)
        }
    }
    
    func delete(
        petitionId: String,
        onComplete: @escaping (GenericResponse) -> Void,
        onError: @escaping (Error) -> Void) async {
            do {
                let result = try await self.service.deletePetition(id: petitionId)
                onComplete(result)
            } catch {
                onError(error)
            }
        }
    
    
}
