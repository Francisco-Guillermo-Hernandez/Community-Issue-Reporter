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
        let query = "SELECT country, region FROM ip_locations WHERE city = ? LIMIT 1"
        var statement: OpaquePointer? = nil
        var locator: Locator = Locator(id: "", country: "", region: "", city: "")
        
        if sqlite3_prepare(dbManager.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (cityName as NSString).utf8String, -1, nil)
            
           if sqlite3_step(statement) == SQLITE_ROW {

                locator = Locator(
                    id: UUID().uuidString,
                    country: String(cString: sqlite3_column_text(statement, 0)),
                    region: String(cString: sqlite3_column_text(statement, 1)),
                    city: cityName
                )
            }
        }
        
        sqlite3_finalize(statement)
        return locator
    }
}
