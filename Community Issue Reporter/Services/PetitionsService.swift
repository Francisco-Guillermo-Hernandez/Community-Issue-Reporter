//
//  PetitionsService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct PetitionsService {
    private let client: ServiceClient
    
    init(client: ServiceClient = ServiceClient()) {
        self.client = client
    }
    
    func fetchPetitions(_ q: PaginatedRequestQueryParams, _ l: LocatorHeaders) async throws -> PaginatedResponse<Petition> {
        return try await self.client.get(path: "petitions/", query: q, headers: l.headers, withOAuth: true)
    }
    
    func fetchPetition(id: Int) async throws -> Petition {
        return try await self.client.get(path: "petitions/\(id)", withOAuth: true)
    }
    
    func createPetition(petition: Petition) async throws -> GenericResponse {
        return try await self.client.post(path: "petitions/create", body: petition, withOAuth: true)
    }
    
    func updatePetition(id: String, petition: Petition) async throws -> GenericResponse {
        return try await self.client.put(path: "petitions/\(id)", body: petition, withOAuth: true)
    }
    
    func fetchPetitionsByUser(_ q: PaginatedRequestQueryParams) async throws -> PaginatedResponse<Petition> {
        return try await self.client.get(path: "petitions/byUser", withOAuth: true)
    }
    
    func signPetition(id: String) async throws -> GenericResponse {
        return try await self.client.patch(
            path: "petitions/\(id)/sign-petition",
            body: [String: String](),
            withOAuth: true,
        )
    }
    
    func deletePetition(id: String) async throws -> GenericResponse {
        return try await self.client.delete(path: "petitions/\(id)", body: [String: String](), withOAuth: true)
    }
}
