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
    
    /// Reference to the application's ModelContainer, set at startup.
    var container: ModelContainer?
    
    private init() {}
    
    /// Queries districts by their thirdLevel (cityName) and countryCode.
    @MainActor
    func findDistrictsBy(thirdLevel: String, countryCode: String, limit: Int = 30, in context: ModelContext) -> [District] {
        let descriptor: FetchDescriptor<District>
        if thirdLevel.isEmpty {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode
                }
            )
        } else {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode &&
                    district.thirdLevel?.localizedStandardContains(thirdLevel) == true
                }
            )
        }
        var finalDescriptor = descriptor
        finalDescriptor.fetchLimit = limit
        do {
            return try context.fetch(finalDescriptor)
        } catch {
            print("Error querying districts by thirdLevel: \(error)")
            return []
        }
    }
    
    /// Queries districts by their groupingName (municipality name) and countryCode.
    @MainActor
    func findDistrictsBy(groupingName: String, countryCode: String, limit: Int = 30, in context: ModelContext) -> [District] {
        let descriptor: FetchDescriptor<District>
        if groupingName.isEmpty {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode
                }
            )
        } else {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode &&
                    district.groupingName?.localizedStandardContains(groupingName) == true
                }
            )
        }
        var finalDescriptor = descriptor
        finalDescriptor.fetchLimit = limit
        do {
            return try context.fetch(finalDescriptor)
        } catch {
            print("Error querying districts by groupingName: \(error)")
            return []
        }
    }
    
    /// Lists districts that meet the condition isDepartmentalCapital = true (the 14 municipalities of El Salvador).
    @MainActor
    func findDepartmentalCapitals(countryCode: String, in context: ModelContext) -> [District] {
        let descriptor = FetchDescriptor<District>(
            predicate: #Predicate<District> { district in
                district.countryCode == countryCode &&
                district.isDepartmentalCapital == true
            }
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error querying departmental capitals: \(error)")
            return []
        }
    }
    
    /// Queries districts by their secondLevel (stateName) and countryCode.
    @MainActor
    func findDistrictsByState(stateName: String, countryCode: String, limit: Int = 30, in context: ModelContext) -> [District] {
        let descriptor: FetchDescriptor<District>
        if stateName.isEmpty {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode
                }
            )
        } else {
            descriptor = FetchDescriptor<District>(
                predicate: #Predicate<District> { district in
                    district.countryCode == countryCode &&
                    district.secondLevel?.localizedStandardContains(stateName) == true
                }
            )
        }
        var finalDescriptor = descriptor
        finalDescriptor.fetchLimit = limit
        do {
            return try context.fetch(finalDescriptor)
        } catch {
            print("Error querying districts by secondLevel: \(error)")
            return []
        }
    }
    
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
