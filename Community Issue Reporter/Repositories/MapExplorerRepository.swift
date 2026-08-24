//
//  MapExplorerRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation
import SwiftData
import CoreLocation

typealias MapExplorerReports = [MapExplorerReport]
typealias MapExplorerReportComplete = @Sendable (MapExplorerReports) -> Void

typealias MapExplorerReportDetail = @Sendable (Result<MapExplorerReport, CommonIntercommunicationErrors>) -> Void

final class MapExplorerRepository {

    static let shared: MapExplorerRepository = .init()
    private var service: MapExplorerService = .init()

    @MainActor
    func cachedReports(countryCode: CountryCode, cityId: String) async -> MapExplorerReports {
        guard let container = SwiftDataLocatorDAO.shared.container else { return [] }
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<MapExplorerReportEntity>(
            predicate: #Predicate { $0.cityId == cityId }
        )
        
        do {
            let entities = try context.fetch(descriptor)
            let decoder = JSONDecoder()
            let reports = entities.compactMap { entity -> MapExplorerReport? in
                return try? decoder.decode(MapExplorerReport.self, from: entity.data)
            }
            return reports
        } catch {
            print("Failed to fetch cached reports: \(error)")
            return []
        }
    }
    
    @MainActor
    func saveReports(
        _ reports: MapExplorerReports,
        cachedReports: MapExplorerReports,
        query: MapExplorerQueryParams,
        cityId: String
    ) async {
        guard let container = SwiftDataLocatorDAO.shared.container else { return }
        let context = container.mainContext
        let encoder = JSONEncoder()
        
        let freshIds = Set(reports.map { $0.id })
        
        let queryLocation = CLLocation(latitude: query.lat, longitude: query.lng)
        let radius = Double(query.radius)
        
        for cached in cachedReports {
            if !freshIds.contains(cached.id) {
                let reportLocation = CLLocation(latitude: cached.lat, longitude: cached.lng)
                let distance = queryLocation.distance(from: reportLocation)
                
                let matchesFilter = distance <= radius &&
                                    query.issueTypeIds.contains(cached.issueTypeId) &&
                                    query.severityIds.contains(cached.severityId) &&
                                    query.statusIds.contains(cached.statusId)
                
                if matchesFilter {
                    let id = cached.id
                    if let entity = try? context.fetch(FetchDescriptor<MapExplorerReportEntity>(predicate: #Predicate { $0.id == id })).first {
                        context.delete(entity)
                    }
                }
            }
        }
        
        for report in reports {
            if let data = try? encoder.encode(report) {
                let entity = MapExplorerReportEntity(
                    id: report.id,
                    cityId: cityId,
                    data: data,
                    updatedAtRaw: report.updatedAtRaw
                )
                context.insert(entity)
            }
        }
        
        try? context.save()
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
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            print("ReportError: ")
            print(error.localizedDescription)
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func listReportsStream(
        for q: MapExplorerQueryParams,
        countryCode: CountryCode,
        cityId: String
    ) -> AsyncThrowingStream<MapExplorerReports, Error> {
        return AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    /// 1. Instantly yield local data to the UI
                    let cached = await self.cachedReports(countryCode: countryCode, cityId: cityId)
                    
                    let queryLocation = CLLocation(latitude: q.lat, longitude: q.lng)
                    let radius = Double(q.radius)
                    
                    let filteredCached = cached.filter { report in
                        let reportLocation = CLLocation(latitude: report.lat, longitude: report.lng)
                        return queryLocation.distance(from: reportLocation) <= radius &&
                               q.issueTypeIds.contains(report.issueTypeId) &&
                               q.severityIds.contains(report.severityId) &&
                               q.statusIds.contains(report.statusId)
                    }

                    if !filteredCached.isEmpty {
                        continuation.yield(filteredCached)
                    }
                    
                    /// 2. Perform the background network validation
                    let freshReports = try await self.listReports(for: q, countryCode: countryCode, cityId: cityId)
                    
                    /// 3. We have fresh data. Save it locally.
                    await self.saveReports(freshReports, cachedReports: cached, query: q, cityId: cityId)
                    
                    /// 4. Yield the fresh data to update the UI
                    continuation.yield(freshReports)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
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
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }

    }

}
