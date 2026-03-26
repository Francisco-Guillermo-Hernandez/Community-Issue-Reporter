//
//  DatabaseUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

func copyDatabaseIfNeeded() {
    let fileManager = FileManager.default
    let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let dbURL = appSupportURL.appendingPathComponent("ip_locations.db")
    let bundleURL = Bundle.main.url(forResource: "ip_locations", withExtension: "db")!

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
    }
}
