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

    func list(
        q: PaginatedRequestQueryParams,
        locator: Locator,
        onComplete: @escaping (PaginatedResponse<Petition>) -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        do {

            let l = LocatorHeaders(headers: [
                HTTPHeader(name: "Country", content: locator.countryCode),
                HTTPHeader(name: "Region", content: locator.region),
                HTTPHeader(name: "City", content: locator.city),
            ])
            
            let result = try await self.service.fetchPetitions(q, l)
            onComplete(result)
        } catch {
            onError(error)
        }
    }

    func create(
        _ petition: Petition,
        onComplete: @escaping (GenericResponse) -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        do {
            let result = try await self.service.createPetition(
                petition: petition
            )
            onComplete(result)
        } catch {
            onError(error)
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
            } catch {
                onError(error)
            }
        }
    
    
}
