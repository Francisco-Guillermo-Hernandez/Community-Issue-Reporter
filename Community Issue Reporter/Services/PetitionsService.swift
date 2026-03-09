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
    
    func fetchPetitions() async throws -> [Petition] {
        return try await self.client.get(path: "petitions")
    }
    
    func fetchPetition(id: Int) async throws -> Petition {
        return try await self.client.get(path: "petitions/\(id)")
    }
    
}
