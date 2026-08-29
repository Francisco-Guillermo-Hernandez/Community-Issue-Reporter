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
    var showErrorAlert: Bool = false
    private(set) var messageError: String = ""
    
    init(countryCode: CountryCode) {
        self.countryCode = countryCode
    }
    
    var cities: [FriendlyCityDistribution] {
        guard let documents = friendlyCities.documents else { return [] }
        return documents.sorted { ($0.isCapitalCity ?? 0) > ($1.isCapitalCity ?? 0) }
    }
    
    func loadLocalCities() {
        friendlyCities = CitiesRepository.shared.loadLocalCities(of: countryCode)
    }
    
    func fetchCitiesByGroupingName() async {
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            groupingName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func fetchCitiesByStateName() async {
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            stateName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func fetchByCityName() async {
        friendlyCities = await CitiesRepository.shared.filter(
            countryCode: countryCode.rawValue,
            page: page,
            cityName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func performSearch() async {
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
    
    func updateCity(city: FriendlyCityDistribution, onUpdated: @escaping () -> Void) {
        Task {
            do {
                isLoading = true
                let result = try await UserRepository.shared.updateDefaultReporting(city.cityId)
                if result == .updated {
                    onUpdated()
                }
            } catch CommonIntercommunicationErrors.unProcessable {
                self.show(error: String(localized: "Your petition cannot be processed, please try again."))
            } catch CommonIntercommunicationErrors.networkError(_) {
                self.show(error: String(localized: "It looks like that your network is experiencing some delays, please try again."))
            } catch CommonIntercommunicationErrors.serverError(_) {
                self.show(error: String(localized: "Server error, please try again."))
            } catch {
                self.show(error: String(localized: "An unexpected error has occurred, please try again."))
            }
            
            isLoading = false
        }
    }
    
    func show(error: String) {
        self.messageError = error
        self.showErrorAlert = true
    }
}
