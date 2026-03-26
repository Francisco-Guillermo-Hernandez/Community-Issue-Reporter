//
//  DatabaseManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    var db: OpaquePointer?
    init () {
        db = open()
    }
    
    func open() -> OpaquePointer? {
        
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dbURL = appSupportURL.appendingPathComponent("ip_locations.db")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        
        return db
    }
}
