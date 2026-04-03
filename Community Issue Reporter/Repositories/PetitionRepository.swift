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
          return try await PetitionsService().fetchPetitions()
        } catch {
          return []
      }
    }
    
    static func create(_ petition: Petition) async -> String {
        do {
            let createdPetition = try await PetitionsService().createPetition(petition: petition)
            return createdPetition.id
        } catch {
            return "-1"
        }
    }
}
