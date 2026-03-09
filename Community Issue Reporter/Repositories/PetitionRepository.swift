//
//  PetitionRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct PetitionRepository {
    static func list() async -> [Petition] {
      do {
          let petitions = try await PetitionsService().fetchPetitions()
          return petitions
          
        } catch {
          return []
      }
    }
}
