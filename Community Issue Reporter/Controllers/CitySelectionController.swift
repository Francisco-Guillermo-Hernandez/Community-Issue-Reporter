//
//  CitySelectionController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 16/6/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class CitySelectionController {
    let countryCode: CountryCode
    
    var page: Int = 1
    var friendlyCities: FriendlyCities = .init(
        documents: [],
        hasNext: false,
        hasPrev: false
    )
    var searchText: String = ""
    var isLoading: Bool = false
    var isSearchActive: Bool = false
    var searchOptionsSelection: CityFilter = .city
    var triggerFeedBack: Bool = false
    
    init(countryCode: CountryCode) {
        self.countryCode = countryCode
    }
    
    var cities: [FriendlyCityDistribution] {
        guard let documents = friendlyCities.documents else { return [] }
        return documents.sorted { ($0.isCapitalCity ?? 0) > ($1.isCapitalCity ?? 0) }
    }
    
    func loadLocalCities() {
        isLoading = true
        friendlyCities = CitiesRepository.shared.loadLocalCities(of: countryCode)
        isLoading = false
    }
    
    func fetchCitiesByGroupingName() async {
        isLoading = true
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            groupingName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        isLoading = false
    }

    func fetchCitiesByStateName() async {
        isLoading = true
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            stateName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        isLoading = false
    }

    func fetchByCityName() async {
        isLoading = true
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            cityName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        isLoading = false
    }
    
    func performSearch() async {
        
        print("searching")
        
//        try? await Task.sleep(for: .milliseconds(450))
        if searchOptionsSelection == .legal { await fetchCitiesByGroupingName() }
        if searchOptionsSelection == .city  { await fetchByCityName() }
        if searchOptionsSelection == .state { await fetchCitiesByStateName() }
    }
    
    func handleSearchOptionsSelectionChange(from oldValue: CityFilter, to newValue: CityFilter) {
        if oldValue != newValue {
            if newValue.rawValue == "legal" {
                searchText = "Municipio de "
            } else {
                searchText = ""
            }
            isSearchActive = true
        }
    }
}
