//
//  MapExplorerRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation

typealias MapExplorerReports = [MapExplorerReport]
typealias MapExplorerReportComplete = @Sendable (MapExplorerReports) -> Void

final class MapExplorerRepository {

    static let shared: MapExplorerRepository = .init()
    private var service: MapExplorerService = .init()

    func cachedReports(countryCode: CountryCode, cityId: String) async -> MapExplorerReports {
        return []
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
