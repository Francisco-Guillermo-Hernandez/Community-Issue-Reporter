//
//  WithTimeout.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

enum TimeoutError: Error {
    case timedOut
}

func withTimeout<T: Sendable>(after duration: Duration, operation: @escaping @Sendable () async throws -> T ) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        
        group.addTask {
            return try await operation()
        }
        

        group.addTask {
            try await Task.sleep(for: duration)
           
            try Task.checkCancellation()
            throw TimeoutError.timedOut
        }
        

        guard let value = try await group.next() else {
            throw TimeoutError.timedOut
        }
        
        group.cancelAll()
        return value
    }
}
