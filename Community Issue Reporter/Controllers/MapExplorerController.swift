//
//  MapExplorerController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 5/7/26.
//

import Foundation
import Observation
import CoreLocation
import MapKit
import SwiftUI

@Observable
@MainActor
final class MapExplorerController {
    var authViewModel: AuthViewModel?
    var settings: SettingsStore?
    
    var reports: [MapExplorerReport] = []
    var hasCenteredOnUser = false
    var searchText = ""
    var selectedStatuses: Set<IssueStatus> = Set(IssueStatus.allCases)
    var searchMarker: IssueMarker?
    var locationManager = LocationManager()
    var showSearchOverlay = false
    var showUserProfileOverlay = false
    var showDetailView = false
    var isPresented = false
    var selectedPlaceID: String?
    var expandedItem: MapExplorerReport?
    
    init() {}
    
    func loadReports() async {
        guard let authViewModel = authViewModel else { return }
        
        let query = MapExplorerQueryParams(
            lat: authViewModel.selectedCity?.coordinates.lat ?? 13.868268,
            lng: authViewModel.selectedCity?.coordinates.lng ?? -89.850968,
            radius: 300,
            issueTypeIds: [1],
            severityIds: [1],
            statusIds: [1]
        )
        
        do {
            self.reports = try await MapExplorerRepository.shared.listReports(
                for: query,
                countryCode: .SV,
                cityId: authViewModel.selectedCity?.cityId ?? "1"
            )
        } catch {
            print(error)
        }
    }
    
    func performSearch() {
        guard let authViewModel = authViewModel, let settings = settings else { return }
        let countryName = settings.countryCodeIso.countryName
        let targetCountry = countryName.isEmpty ? "El Salvador" : countryName
        
        print(countryName)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = currentRegion(c: authViewModel.cameraPosition)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self = self else { return }
            guard let item = response?.mapItems.first(where: { item in
                if let identifier = item.addressRepresentations?.region?.identifier {
                    if identifier.localizedCaseInsensitiveCompare(self.settings?.countryCodeIso.rawValue ?? "") == .orderedSame {
                        return true
                    }
                }
                if let regionName = item.addressRepresentations?.regionName {
                    if regionName.localizedCaseInsensitiveContains(targetCountry) {
                        return true
                    }
                }
                return false
            }) else { return }
            
            let coordinate = item.location.coordinate
            let address = item.address?.fullAddress ?? item.address?.shortAddress ?? "Unknown"
            self.searchMarker = IssueMarker(
                id: UUID().uuidString, 
                title: item.name ?? String(localized: "Result"),
                description: "",
                status: 1,
                coordinate: coordinate,
                issueType: 1,
                severity: 1,
                matterToSolveId: 1,
                address: address
            )
            self.authViewModel?.cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
        }
    }
    
    func performSearch(with completion: MKLocalSearchCompletion) {
        guard let authViewModel = authViewModel, let settings = settings else { return }
        let countryName = settings.countryCodeIso.countryName
        let targetCountry = countryName.isEmpty ? "El Salvador" : countryName
        
        let request = MKLocalSearch.Request(completion: completion)
        request.region = currentRegion(c: authViewModel.cameraPosition)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self = self else { return }
            guard let item = response?.mapItems.first(where: { item in
                if let identifier = item.addressRepresentations?.region?.identifier {
                    if identifier.localizedCaseInsensitiveCompare(self.settings?.countryCodeIso.rawValue ?? "") == .orderedSame {
                        return true
                    }
                }
                if let regionName = item.addressRepresentations?.regionName {
                    if regionName.localizedCaseInsensitiveContains(targetCountry) {
                        return true
                    }
                }
                return false
            }) else { return }
            
            let coordinate = item.location.coordinate
            let address = item.address?.fullAddress ?? item.address?.shortAddress ?? "Unknown"
            self.searchMarker = IssueMarker(
                id: UUID().uuidString, 
                title: item.name ?? String(localized: "Result"),
                description: "",
                status: 1,
                coordinate: coordinate, 
                issueType: 1,
                severity: 1,
                matterToSolveId: 1,
                address: address
            )
            self.authViewModel?.cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
        }
    }
    
    func applySuggestion(_ suggestion: SearchSuggestion) {
        searchText = suggestion.title
        performSearch(with: suggestion.completion)
        showSearchOverlay = false
    }
    
    func centerMapOnUserLocation() {
        guard let authViewModel = authViewModel else { return }
        locationManager.requestAuthorization()
        guard let location = locationManager.lastLocation else { return }
        hasCenteredOnUser = true
        authViewModel.cameraPosition = .region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.0082, longitudeDelta: 0.0082)
            )
        )
    }
    
    func handleMapMovement(center: CLLocationCoordinate2D) {
        guard let authViewModel = authViewModel else { return }
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
       
        Task {
            try? await Task.sleep(for: .milliseconds(550))
            guard !Task.isCancelled else { return }
            
            print(authViewModel.cameraPosition.region?.span.latitudeDelta ?? "")
            
            guard let request = MKReverseGeocodingRequest(location: location) else { return }
            let mapItems = try? await request.mapItems
            guard let mapItem = mapItems?.first else { return }
            
            let country = mapItem.addressRepresentations?.region?.identifier
            ?? mapItem.addressRepresentations?.regionName
            ?? "-1"
            
            let cityName = mapItem.addressRepresentations?.cityName ?? "-1"
            
            print(country)
            print(cityName)
        }
    }
}

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
}
