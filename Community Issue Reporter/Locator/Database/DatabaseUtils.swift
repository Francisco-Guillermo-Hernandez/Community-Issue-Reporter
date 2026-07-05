//
//  DatabaseUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

func copyDatabaseIfNeeded() {
    let fileManager = FileManager.default
    guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        print("Error: Application Support directory not found.")
        return
    }
    let dbURL = appSupportURL.appendingPathComponent("districts.db")
    
    guard let bundleURL = Bundle.main.url(forResource: "districts", withExtension: "db") else {
        print("Error: districts.db not found in main bundle.")
        return
    }

    if !fileManager.fileExists(atPath: appSupportURL.path) {
        try? fileManager.createDirectory(at: appSupportURL, withIntermediateDirectories: true, attributes: nil)
    }

    if !fileManager.fileExists(atPath: dbURL.path) {
        do {
            try fileManager.copyItem(at: bundleURL, to: dbURL)
            print("Database copied to documents directory.")
        } catch {
            print("Error copying database: \(error.localizedDescription)")
        }
    } else {
        /// If the file exists but has a size of 0 bytes, it was likely auto-created by SQLite
        /// on a previous failed run. We overwrite it with the valid bundle database.
        if let attributes = try? fileManager.attributesOfItem(atPath: dbURL.path),
           let fileSize = attributes[.size] as? UInt64,
           fileSize == 0 {
            do {
                try fileManager.removeItem(at: dbURL)
                try fileManager.copyItem(at: bundleURL, to: dbURL)
                print("Empty database file found and replaced with bundle database.")
            } catch {
                print("Error replacing empty database: \(error.localizedDescription)")
            }
        }
    }
}
