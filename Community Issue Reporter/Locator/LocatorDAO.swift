//
//  LocatorDAO.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation
import SQLite3

final class LocatorDAO {
    
    static let shared = LocatorDAO()
    private let dbManager: DatabaseManager
    private init() {
        dbManager = DatabaseManager()
    }
    
    private func exec(statement: OpaquePointer?) -> Locator {
        let locator: Locator = .init()
        if sqlite3_step(statement) == SQLITE_ROW {
            locator.countryCode = string(from: statement, at: 0)
            locator.firstLevel = string(from: statement, at: 1)
            locator.secondLevel = string(from: statement, at: 2)
            locator.thirdLevel = string(from: statement, at: 3)
            locator.groupingId = string(from: statement, at: 4)
            locator.cityId = string(from: statement, at: 5)
            locator.groupingName = string(from: statement, at: 6)
            locator.groupingNameCode = string(from: statement, at: 7)
            locator.lat = sqlite3_column_double(statement, 8)
            locator.lng = sqlite3_column_double(statement, 9)
            locator.geoCode = string(from: statement, at: 10)
            locator.zipCode = string(from: statement, at: 11)
            locator.isCapitalCityRaw = Int(sqlite3_column_int(statement, 12))
            locator.isDepartmentalCapitalRaw = Int(sqlite3_column_int(statement, 13))
            locator.cityNameSortKey = string(from: statement, at: 14)
        }
        
        return locator
    }
    
    func findBy(countryCode: String, cityName: String) -> Locator {
        
        let query = "SELECT countryCode, firstLevel, secondLevel, thirdLevel, groupingId, cityId, groupingName, groupingNameCode, lat, lng, geoCode, zipCode, isCapitalCity, isDepartmentalCapital, cityNameSortKey FROM cities WHERE countryCode = ? AND thirdLevel = ? LIMIT 1;"
        var statement: OpaquePointer? = nil
        
        print("cityName: \(cityName)")
        
        print("countryCode:")
        print(countryCode)
        
        var locator: Locator = .init()
        let status = sqlite3_prepare(dbManager.db, query, -1, &statement, nil)
        
        if status == SQLITE_OK {
    
            /// Bind parameter 1 countryCode
            sqlite3_bind_text(statement, 1, (countryCode as NSString).utf8String, -1, nil)
            /// Bind parameter 2 (thirdLevel) -> cityName
            sqlite3_bind_text(statement, 2, (cityName as NSString).utf8String, -1, nil)
            
            locator = exec(statement: statement)
            
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(dbManager.db))
               print("Error preparing statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        return locator
    }
    
    func findBy(countryCode: String, cityNameSortKey: String) -> Locator {
        return .init()
    }
    
    /// Safely unwraps and reads string fields from a SQLite statement column
    private func string(from statement: OpaquePointer?, at index: Int32) -> String {
        guard let cString = sqlite3_column_text(statement, index) else {
            return ""
        }
        return String(cString: cString)
    }
}

