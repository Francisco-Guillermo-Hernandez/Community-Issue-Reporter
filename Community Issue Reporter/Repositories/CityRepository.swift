//
//  CityRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/5/26.
//

import Foundation

typealias FriendlyCities = PaginatedResponse<FriendlyCityDistribution>

final class CitiesRepository {

    static let shared = CitiesRepository()
    private let service: CityService
    private init() {
        self.service = CityService()
    }
    
    func loadLocalCities(with countryCode: String) -> FriendlyCities {
        // Locate the file in the bundle
        guard let url = Bundle.main.url(forResource: "\(countryCode).cities", withExtension: "json") else {
            fatalError("Failed to locate file in bundle.")
        }

        do {
            // Load the data into memory
            let data = try Data(contentsOf: url)
            
            // Decode the JSON into your
            let decoder = JSONDecoder()
            let documents = try decoder.decode([FriendlyCityDistribution].self, from: data)
            
            return PaginatedResponse(documents: documents, hasNext: false, hasPrev: false)
        } catch {
            print("Error decoding JSON: \(error)")
            return PaginatedResponse(
                documents: [],
                hasNext: false,
                hasPrev: false
            )
        }
    }


    func filter(
        countryCode: String,
        page: Int,
        departmentalCapital: Bool? = nil,
        stateName: String? = nil,
        cityName: String? = nil,
        groupingName: String? = nil
    ) async -> FriendlyCities {
        do {
            // Build the query to be sent to the server
            let query = PaginatedRequestQueryParams(
                page: page,
                limit: 16,
                countryCode: countryCode,
                departmentalCapital: departmentalCapital,
                cityName: cityName,
                stateName: stateName,
                groupingName: groupingName
            )
         
            // Fetch the results
            return try await self.service.filter(q: query)
            
        } catch {
            return PaginatedResponse(
                documents: [],
                hasNext: false,
                hasPrev: false
            )
        }
    }
}
