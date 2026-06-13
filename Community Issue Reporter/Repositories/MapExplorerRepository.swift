//
//  MapExplorerRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation

enum CommonIntercommunicationErrors: Error {
    case delayed
    case timedOut
    case removed
    case notFound
    case serverError(String)
    case notAuthorized
    case networkError(String)
    case genericError(String)
    case notImplemented
}

typealias MapExplorerReports = [MapExplorerReport]
typealias MapExplorerReportComplete = @Sendable (MapExplorerReports) -> Void

// typealias UserNameCompletion = (Result<String, UserError> ) -> Void

typealias MapExplorerReportDetail = @Sendable (Result<MapExplorerReport, CommonIntercommunicationErrors>) -> Void

final class MapExplorerRepository {

    static let shared: MapExplorerRepository = .init()
    private var service: MapExplorerService = .init()

    func cachedReports(countryCode: CountryCode, cityId: String) async -> MapExplorerReports {
        return []
    }
    
    func report(
        _ id: String,
        countryCode: CountryCode,
        cityId: String,
        completion: MapExplorerReportDetail,
    ) async {
        do {
            let headers = [
                HTTPHeader(name: "countryCode", content: countryCode.rawValue),
                HTTPHeader(name: "cityId", content: cityId),
                HTTPHeader(
                    name: "Content-Type",
                    content: "application/x-msgpack"
                ),
            ]
            
            let result = try await service.report(id, h: headers)
            
            completion(.success(result))
        } catch ServiceError.notFound {
            completion(.failure(.notFound))
        } catch ServiceError.serverError(let message) {
            completion(.failure(.serverError(message)))
        } catch {
            completion(.failure(.genericError(error.localizedDescription)))
        }
    }
    
    func listReports(
        for q: MapExplorerQueryParams,
        countryCode: CountryCode,
        cityId: String,
        onComplete: MapExplorerReportComplete,
        onError: ErrorHandler
    ) async {
        do {
            let headers = [
                HTTPHeader(name: "countryCode", content: countryCode.rawValue),
                HTTPHeader(name: "cityId", content: cityId),
                HTTPHeader(
                    name: "Content-Type",
                    content: "application/x-msgpack"
                ),
            ]

            let result = try await service.reports(q: q, h: headers)
        

            onComplete(result)
            
//            return result
            
        } catch {
            onError(error)
//            return []
        }

    }

}
