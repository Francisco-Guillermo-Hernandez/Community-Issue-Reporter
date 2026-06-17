//
//  CitySelectionController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 16/6/26.
//

import SwiftUI
internal import Combine

@MainActor
final class CitySelectionController: ObservableObject {
    let countryCode: CountryCode
    
    @Published var page: Int = 1
    @Published var friendlyCities: FriendlyCities = .init(
        documents: [],
        hasNext: false,
        hasPrev: false
    )
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isSearchActive: Bool = false
    @Published var searchOptionsSelection: CityFilter = .city
    @Published var triggerFeedBack: Bool = false
    
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
        try? await Task.sleep(for: .milliseconds(450))
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
