//
//  DatabaseMigrator.swift
//  migration
//
//  Created by Francisco Hernandez on 2/7/26.
//

import Foundation
import SQLite3
import SwiftData

@MainActor
final class DatabaseMigrator {
    
    static let shared = DatabaseMigrator()
    
    private init() {}
    
    func migrateIfNeeded(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<District>()
        do {
            let count = try modelContext.fetchCount(fetchDescriptor)
            if count > 0 {
                print("SwiftData already populated with \(count) cities. Skipping migration.")
                return
            }
        } catch {
            print("Error checking SwiftData count: \(error)")
        }
        
        print("Starting migration from SQLite to SwiftData...")
        
        let fileManager = FileManager.default
        guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error: Application Support directory not found.")
            return
        }
        let dbURL = appSupportURL.appendingPathComponent("districts.db")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            print("Error opening districts.db for migration.")
            return
        }
        defer {
            sqlite3_close(db)
        }
        
        var citiesMap: [String: District] = [:]
        let citiesQuery = "SELECT cityId, zipCode, cityNameSortKey, lat, lng, countryCode, firstLevel, groupingId, groupingName, groupingNameSortKey, groupingNameCode, isCapitalCity, isDepartmentalCapital, legalGroupName, secondLevel, stateNameSortKey, thirdLevel, geoCode FROM cities;"
        var citiesStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, citiesQuery, -1, &citiesStatement, nil) == SQLITE_OK {
            while sqlite3_step(citiesStatement) == SQLITE_ROW {
                let cityId = getString(from: citiesStatement, at: 0)
                let zipCode = getOptionalString(from: citiesStatement, at: 1)
                let cityNameSortKey = getOptionalString(from: citiesStatement, at: 2)
                let lat = sqlite3_column_double(citiesStatement, 3)
                let lng = sqlite3_column_double(citiesStatement, 4)
                let countryCode = getString(from: citiesStatement, at: 5)
                let firstLevel = getOptionalString(from: citiesStatement, at: 6)
                let groupingId = getOptionalString(from: citiesStatement, at: 7)
                let groupingName = getOptionalString(from: citiesStatement, at: 8)
                let groupingNameSortKey = getOptionalString(from: citiesStatement, at: 9)
                let groupingNameCode = getOptionalString(from: citiesStatement, at: 10)
                let isCapitalCity = sqlite3_column_int(citiesStatement, 11) == 1
                let isDepartmentalCapital = sqlite3_column_int(citiesStatement, 12) == 1
                let legalGroupName = getOptionalString(from: citiesStatement, at: 13)
                let secondLevel = getOptionalString(from: citiesStatement, at: 14)
                let stateNameSortKey = getOptionalString(from: citiesStatement, at: 15)
                let thirdLevel = getOptionalString(from: citiesStatement, at: 16)
                let geoCode = getOptionalString(from: citiesStatement, at: 17)
                
                let city = District(
                    cityId: cityId,
                    zipCode: zipCode,
                    cityNameSortKey: cityNameSortKey,
                    lat: lat,
                    lng: lng,
                    countryCode: countryCode,
                    firstLevel: firstLevel,
                    groupingId: groupingId,
                    groupingName: groupingName,
                    groupingNameSortKey: groupingNameSortKey,
                    groupingNameCode: groupingNameCode,
                    isCapitalCity: isCapitalCity,
                    isDepartmentalCapital: isDepartmentalCapital,
                    legalGroupName: legalGroupName,
                    secondLevel: secondLevel,
                    stateNameSortKey: stateNameSortKey,
                    thirdLevel: thirdLevel,
                    geoCode: geoCode
                )
                citiesMap[cityId] = city
                modelContext.insert(city)
            }
        } else {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing cities statement: \(errMsg)")
        }
        sqlite3_finalize(citiesStatement)
        
        let cantonsQuery = "SELECT code, name, cityId FROM cantons;"
        var cantonsStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, cantonsQuery, -1, &cantonsStatement, nil) == SQLITE_OK {
            while sqlite3_step(cantonsStatement) == SQLITE_ROW {
                let code = getString(from: cantonsStatement, at: 0)
                let name = getOptionalString(from: cantonsStatement, at: 1)
                let cityId = getOptionalString(from: cantonsStatement, at: 2)
                
                let canton = Canton(code: code, name: name, cityId: cityId)
                
                if let cityId = cityId, let city = citiesMap[cityId] {
                    canton.district = city
                    city.cantons?.append(canton)
                }
                modelContext.insert(canton)
            }
        } else {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing cantons statement: \(errMsg)")
        }
        sqlite3_finalize(cantonsStatement)
        
        do {
            try modelContext.save()
            print("SQLite database successfully migrated to SwiftData.")
        } catch {
            print("Error saving migrated data in SwiftData: \(error)")
        }
    }
    
    private func getString(from statement: OpaquePointer?, at index: Int32) -> String {
        guard let cString = sqlite3_column_text(statement, index) else {
            return ""
        }
        return String(cString: cString)
    }
    
    private func getOptionalString(from statement: OpaquePointer?, at index: Int32) -> String? {
        guard let cString = sqlite3_column_text(statement, index) else {
            return nil
        }
        return String(cString: cString)
    }
}
