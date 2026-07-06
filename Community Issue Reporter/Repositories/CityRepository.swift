//
//  CityRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/5/26.
//

import Foundation
import SwiftData

typealias FriendlyCities = PaginatedResponse<FriendlyCityDistribution>

final class CitiesRepository {

    static let shared = CitiesRepository()
    private let service: CityService
    private init() {
        self.service = CityService()
    }
    
    func loadLocalCities(of countryCode: CountryCode) -> FriendlyCities {
        // Locate the file in the bundle
        guard let url = Bundle.main.url(forResource: "\(countryCode.rawValue).cities", withExtension: "json") else {
            fatalError("Failed to locate file in bundle.")
        }

        do {
            // Load the data into memory
            let data = try Data(contentsOf: url)
            
            // Decode the JSON into your
            let decoder = JSONDecoder()
            var documents = try decoder.decode([FriendlyCityDistribution].self, from: data)
            
            // Add the selected city from UserDefaults if it exists at position 0
            if let savedCityData = UserDefaults.standard.data(forKey: "selected_city"),
               let decodedCity = try? decoder.decode(FriendlyCityDistribution.self, from: savedCityData) {
                // Remove the city if it's already in the list to avoid duplicates, then insert at 0
                documents.removeAll { $0.cityId == decodedCity.cityId }
                documents.insert(decodedCity, at: 0)
            }
            
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
        guard let container = SwiftDataLocatorDAO.shared.container else {
            print("Error: SwiftData container is not initialized in CitiesRepository.")
            return PaginatedResponse(documents: [], hasNext: false, hasPrev: false)
        }
        
        let documents = await MainActor.run { () -> [FriendlyCityDistribution] in
            let context = container.mainContext
            let districts: [District]
            
            if departmentalCapital == true {
                districts = SwiftDataLocatorDAO.shared.findDepartmentalCapitals(
                    countryCode: countryCode,
                    in: context
                )
            } else if let groupingName = groupingName, !groupingName.isEmpty {
                districts = SwiftDataLocatorDAO.shared.findDistrictsBy(
                    groupingName: groupingName,
                    countryCode: countryCode,
                    limit: 30,
                    in: context
                )
            } else if let cityName = cityName, !cityName.isEmpty {
                districts = SwiftDataLocatorDAO.shared.findDistrictsBy(
                    thirdLevel: cityName,
                    countryCode: countryCode,
                    limit: 30,
                    in: context
                )
            } else if let stateName = stateName, !stateName.isEmpty {
                districts = SwiftDataLocatorDAO.shared.findDistrictsByState(
                    stateName: stateName,
                    countryCode: countryCode,
                    limit: 30,
                    in: context
                )
            } else {
                districts = SwiftDataLocatorDAO.shared.findDistrictsBy(
                    thirdLevel: "",
                    countryCode: countryCode,
                    limit: 30,
                    in: context
                )
            }
            
            return districts.map { FriendlyCityDistribution(from: $0) }
        }
        
        return PaginatedResponse(
            documents: documents,
            hasNext: false,
            hasPrev: false
        )
    }
}

extension FriendlyCityDistribution {
    init(from district: District) {
        self.init(
            cityId: district.cityId,
            firstLevel: district.firstLevel ?? "",
            secondLevel: district.secondLevel ?? "",
            thirdLevel: district.thirdLevel ?? "",
            ZipCode: district.zipCode,
            legalGroupName: district.legalGroupName ?? "",
            coordinates: Coordinate(lat: district.lat, lng: district.lng),
            isCapitalCity: district.isCapitalCity ? 1 : 0,
            isDepartmentalCapital: district.isDepartmentalCapital ? 1 : 0,
            groupingId: district.groupingId,
            groupingName: district.groupingName
        )
    }
}
