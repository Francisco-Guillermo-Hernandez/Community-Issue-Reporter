//
//  LocatorDAO.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation
import SQLite3

class LocatorDAO {
    
    let dbManager: DatabaseManager
    init() {
        dbManager = DatabaseManager()
    }
    
    func findBy(cityName: String) -> Locator {
        let query = "SELECT countryCode, country, region FROM ip_locations WHERE city = ? LIMIT 1"
        var statement: OpaquePointer? = nil
        var locator: Locator = Locator(id: "", countryCode: "", country: "", region: "", city: "")
        
        if sqlite3_prepare(dbManager.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (cityName as NSString).utf8String, -1, nil)
            
           if sqlite3_step(statement) == SQLITE_ROW {

                locator = Locator(
                    id: UUID().uuidString,
                    countryCode: String(cString: sqlite3_column_text(statement, 0)),
                    country: String(cString: sqlite3_column_text(statement, 1)),
                    region: String(cString: sqlite3_column_text(statement, 2)),
                    city: cityName
                )
            }
        }
        
        sqlite3_finalize(statement)
        return locator
    }
}
