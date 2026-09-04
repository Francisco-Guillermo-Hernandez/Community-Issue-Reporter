//
//  CounterRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/9/26.
//

import Foundation

final class CounterRepository {
    
    static let shared = CounterRepository()
    private var service: CounterService = .init()
    var headers: [HTTPHeader]
    private init() {
        headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
        ]
    }
    
    func increase() async throws {
        do {
            _ = try await service.increase(headers)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func count() async -> Int? {
        do {
            let response = try await service.count(headers)
            return response.data.count
        } catch {
            return nil
        }
    }
}
