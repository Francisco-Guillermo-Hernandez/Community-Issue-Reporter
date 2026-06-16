//
//  MapExplorerRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation


typealias MapExplorerReports = [MapExplorerReport]
typealias MapExplorerReportComplete = @Sendable (MapExplorerReports) -> Void

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
        cityId: String
    ) async throws -> MapExplorerReport {
        do {
            let headers = [
                HTTPHeader(name: "countryCode", content: countryCode.rawValue),
                HTTPHeader(name: "cityId", content: cityId),
                HTTPHeader(
                    name: "Content-Type",
                    content: "application/x-msgpack"
                ),
            ]
            
            return try await service.report(id, h: headers)
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.message)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            print("ReportError: ")
            print(error.localizedDescription)
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func listReports(
        for q: MapExplorerQueryParams,
        countryCode: CountryCode,
        cityId: String
    ) async throws -> MapExplorerReports {
        do {
            let headers = [
                HTTPHeader(name: "countryCode", content: countryCode.rawValue),
                HTTPHeader(name: "cityId", content: cityId),
                HTTPHeader(
                    name: "Content-Type",
                    content: "application/x-msgpack"
                ),
            ]

            return try await service.reports(q: q, h: headers)
            
        } catch ServiceError.badRequest(let result) {
            throw CommonIntercommunicationErrors.invalidPetition(result.code)
        } catch ServiceError.notFound {
            throw CommonIntercommunicationErrors.notFound
        } catch ServiceError.serverError(let code) {
          throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }

    }

}
