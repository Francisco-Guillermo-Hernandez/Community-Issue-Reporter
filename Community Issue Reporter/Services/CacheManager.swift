//
//  CacheManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/5/26.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    // In-memory cache
    private let memoryCache = NSCache<NSString, NSData>()
    
    // Disk cache URL
    private let fileManager = FileManager.default
    private var diskCacheURL: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("CustomAPICache")
    }
    
    private init() {
        // Create the directory if it doesn't exist
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    // MARK: - Save Data
    func save(data: Data, forKey key: String) {
        //  Save to Memory
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        // Save to Disk
        let fileURL = diskCacheURL.appendingPathComponent(key)
        try? data.write(to: fileURL)
    }

    // MARK: - Retrieve Data
    func getData(forKey key: String) -> Data? {
        // Check Memory Cache First
        if let memoryData = memoryCache.object(forKey: key as NSString) as Data? {
            return memoryData
        }
        
        // Check Disk Cache
        let fileURL = diskCacheURL.appendingPathComponent(key)
        if let diskData = try? Data(contentsOf: fileURL) {
            // Repopulate memory cache
            memoryCache.setObject(diskData as NSData, forKey: key as NSString)
            return diskData
        }
        
        return nil
    }

    // MARK: - Clear Cache
    func clearCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: diskCacheURL)
    }
}

struct CacheEntry: Codable {
    let data: Data
    let timestamp: Date
    
    var isExpired: Bool {
        // Data is stale after 1 hour
        return Date().timeIntervalSince(timestamp) > 3600
    }
}
