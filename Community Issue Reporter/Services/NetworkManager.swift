//
//  NetworkManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/5/26.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        // Specify a disk capacity of 50MB and memory capacity of 10MB
        
        let memoryCapacity = 10 * 1024 * 1024
        let diskCapacity = 75 * 1024 * 1024
        config.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "reportamelo_app_cache")
        // Use default protocol cache policy
        config.requestCachePolicy = .useProtocolCachePolicy
        
        self.session = URLSession(configuration: config)
    }
    
    func fetchData(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
    
}

