//
//  migrationTests.swift
//  migrationTests
//
//  Created by Francisco Hernandez on 1/7/26.
//

import Testing
import SwiftData
@testable import Community_Issue_Reporter

struct migrationTests {

    @Test func testFindByCity() async throws {
        let locator = await LocatorDAO.shared.findBy(countryCode: "SV", cityName: "San Salvador")
        
        #expect(locator.countryCode == "SV")
        #expect(locator.firstLevel == "El Salvador")
        #expect(locator.secondLevel == "San Salvador")
        #expect(locator.thirdLevel == "San Salvador")
        #expect(locator.cityId == "a67b90f9-1d76-4835-a994-03cd04f1d619")
        #expect(locator.lat == 13.6979857)
        #expect(locator.lng == -89.1918083)
        #expect(locator.isCapitalCity == true)
    }

    @Test func testSwiftDataMigrationAndFinders() async throws {
        // Create an in-memory container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: District.self, Canton.self, configurations: config)
        let context = ModelContext(container)
        
        // Perform migration
        await DatabaseMigrator.shared.migrateIfNeeded(modelContext: context)
        
        // Verify migration counts
        let citiesFetch = FetchDescriptor<District>()
        let citiesCount = try context.fetchCount(citiesFetch)
        #expect(citiesCount == 262)
        
        let cantonsFetch = FetchDescriptor<Canton>()
        let cantonsCount = try context.fetchCount(cantonsFetch)
        #expect(cantonsCount == 2460)
        
        // Test findCityBy(cityId:countryCode:)
        let sanSalvador = await SwiftDataLocatorDAO.shared.findCityBy(
            cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
            countryCode: "SV",
            in: context
        )
        #expect(sanSalvador != nil)
        #expect(sanSalvador?.thirdLevel == "San Salvador")
        #expect(sanSalvador?.firstLevel == "El Salvador")
        
        // Test findCityBy(name:)
        let foundByName = await SwiftDataLocatorDAO.shared.findCityBy(name: "San Salvador", in: context)
        #expect(foundByName != nil)
        #expect(foundByName?.cityId == "a67b90f9-1d76-4835-a994-03cd04f1d619")
        
        // Test getCantonsOf(cityId:)
        let cantons = await SwiftDataLocatorDAO.shared.getCantonsOf(cityId: "ed29da1c-77b5-449c-80e4-a0fc00846d25", in: context)
        #expect(cantons.count > 0)
        #expect(cantons.contains(where: { $0.name == "El Coyol" }))
    }

}
