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
    
    func findBy(cityName: String, country: String) -> Locator {
        let query = "SELECT countryCode, country, region FROM ip_locations WHERE city = ? and country = ? or countryCode = ? LIMIT 1"
        var statement: OpaquePointer? = nil
        var locator: Locator = .init(id: "", countryCode: "", country: "", region: "", city: "", address: "")
        
        if sqlite3_prepare(dbManager.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (cityName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (country as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (country as NSString).utf8String, -1, nil)
            
           if sqlite3_step(statement) == SQLITE_ROW {

                locator = Locator(
                    id: UUID().uuidString,
                    countryCode: String(cString: sqlite3_column_text(statement, 0)),
                    country: String(cString: sqlite3_column_text(statement, 1)),
                    region: String(cString: sqlite3_column_text(statement, 2)),
                    city: cityName,
                    address: ""
                )
            }
        }
        
        sqlite3_finalize(statement)
        return locator
    }
}
