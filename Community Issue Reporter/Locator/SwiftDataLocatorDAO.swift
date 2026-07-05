//
//  SwiftDataLocatorDAO.swift
//  migration
//
//  Created by Francisco Hernandez on 2/7/26.
//

import Foundation
import SwiftData

final class SwiftDataLocatorDAO {
    
    static let shared = SwiftDataLocatorDAO()
    
    private init() {}
    
    /// Finds a city by its cityId and countryCode.
    @MainActor
    func findCityBy(cityId: String, countryCode: String, in context: ModelContext) -> District? {
        var descriptor = FetchDescriptor<District>(
            predicate: #Predicate<District> { city in
                city.cityId == cityId && city.countryCode == countryCode
            }
        )
        descriptor.fetchLimit = 1
        do {
            return try context.fetch(descriptor).first
        } catch {
            print("Error finding city by cityId and countryCode: \(error)")
            return nil
        }
    }
    
    /// Finds a city by its name (thirdLevel).
    @MainActor
    func findCityBy(name: String, in context: ModelContext) -> District? {
        var descriptor = FetchDescriptor<District>(
            predicate: #Predicate<District> { city in
                city.thirdLevel == name
            }
        )
        descriptor.fetchLimit = 1
        do {
            return try context.fetch(descriptor).first
        } catch {
            print("Error finding city by name: \(error)")
            return nil
        }
    }
    
    /// Gets all cantons of a city by its cityId.
    @MainActor
    func getCantonsOf(cityId: String, in context: ModelContext) -> [Canton] {
        let descriptor = FetchDescriptor<Canton>(
            predicate: #Predicate<Canton> { canton in
                canton.cityId == cityId
            }
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching cantons for cityId \(cityId): \(error)")
            return []
        }
    }
}
