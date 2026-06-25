//
//  NetworkManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/5/26.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        
        /// Time to wait for additional data to arrive (Default is 60)
        configuration.timeoutIntervalForRequest = 16.0

        /// Time to wait for the whole resource to download (Optional)
        configuration.timeoutIntervalForResource = 30.0
       
        /// Specify a disk capacity of 200MB and memory capacity of 10MB
        let memoryCapacity = 10 * 1024 * 1024
        let diskCapacity = 200 * 1024 * 1024
        
        /// Defining the cache
        configuration.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "reportamelo_app_cache")
        
        /// Use default protocol cache policy
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        self.session = URLSession(configuration: configuration)
    }
    
    /// A wrapper for session data
    func fetch(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
    
    /// A wrapper for session upload
    func upload(using request: URLRequest, contentOf body: Data, with delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        return try await session.upload(for: request, from: body, delegate: delegate)
    }
}

