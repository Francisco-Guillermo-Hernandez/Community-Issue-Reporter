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
        copyDatabaseIfNeeded()
        db = open()
    }
    
    func open() -> OpaquePointer? {
        let dbURL = URL.applicationSupportDirectory.appending(path: "districts.db")
        
        var db: OpaquePointer? = nil
        
        let openResult = dbURL.withUnsafeFileSystemRepresentation { fileSystemPath in
            sqlite3_open(fileSystemPath, &db)
        }
        
        if openResult != SQLITE_OK {
            print("error opening database")
            return nil
        }
        
        return db
    }
}
