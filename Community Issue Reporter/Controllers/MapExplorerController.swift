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
    static let shared = MapExplorerController()
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
    var selection: String = ""
    var isSearchExpanded: Bool = false
    var isSearchActivated: Bool = false
    var searchItems: [String] = []
    
    init() {
        self.searchItems = [
            IssueStatus.confirmed.title,
            IssueStatus.inProgress.title,
            IssueStatus.fixed.title,
            IssueStatus.petitionToSign.title,
            IssueStatus.assigned.title,
        ] // IssueStatus.allCases.map(\.title)
    }
    private var currentFetchID = UUID()
    
    func loadReports() async {
        guard let authViewModel = authViewModel else { return }
        
        let fetchID = UUID()
        self.currentFetchID = fetchID
        
        let query = MapExplorerQueryParams(
            lat: authViewModel.cameraPosition.region?.center.latitude ?? authViewModel.selectedCity?.coordinates.lat ?? 13.868268,
            lng: authViewModel.cameraPosition.region?.center.longitude ?? authViewModel.selectedCity?.coordinates.lng ?? -89.850968,
            radius: 600,
            issueTypeIds: [1],
            severityIds: [1],
            statusIds: [1]
        )
        
        do {
            let fetchedReports = try await MapExplorerRepository.shared.listReports(
                for: query,
                countryCode: .SV,
                cityId: authViewModel.selectedCity?.cityId ?? "1"
            )
            guard self.currentFetchID == fetchID else { return }
            self.reports = fetchedReports
        } catch CommonIntercommunicationErrors.invalidPetition(let code) {
            Toast.shared.show(message: String(localized: "Invalid request (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.notFound {
            Toast.shared.show(message: String(localized: "Reports not found"), type: .error)
        } catch CommonIntercommunicationErrors.serverError(let code) {
            Toast.shared.show(message: String(localized: "Server error (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.networkError(let message) {
            Toast.shared.show(message: String(localized: "Network error: \(message)"), type: .error)
        } catch CommonIntercommunicationErrors.genericError(let message) {
            Toast.shared.show(message: String(localized: "Error: \(message)"), type: .error)
        } catch {
            print(error)
            Toast.shared.show(message: String(localized: "An unexpected error occurred"), type: .error)
        }
    }
    
    func loadReportsWith(_ coordinates: CLLocationCoordinate2D) async {
        let fetchID = UUID()
        self.currentFetchID = fetchID
        
        do {
            let query = MapExplorerQueryParams(
                lat: coordinates.latitude,
                lng: coordinates.longitude,
                radius: 300,
                issueTypeIds: IssueTypes.allCases.compactMap(\.identifier),
                severityIds: Severity.allCases.compactMap(\.identifier),
                statusIds: IssueStatus.allCases.compactMap(\.identifier)
            )
            
            print("[QUERY] : debugging")
            dump(query)
            
            let fetchedReports = try await MapExplorerRepository.shared.listReports(
                for: query,
                countryCode: .SV,
                cityId: authViewModel?.selectedCity?.cityId ?? "1"
            )
            guard self.currentFetchID == fetchID else { return }
            self.reports = fetchedReports
        } catch CommonIntercommunicationErrors.invalidPetition(let code) {
            Toast.shared.show(message: String(localized: "Invalid request (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.notFound {
            Toast.shared.show(message: String(localized: "Reports not found"), type: .error)
        } catch CommonIntercommunicationErrors.serverError(let code) {
            Toast.shared.show(message: String(localized: "Server error (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.networkError(let message) {
            Toast.shared.show(message: String(localized: "Network error: \(message)"), type: .error)
        } catch CommonIntercommunicationErrors.genericError(let message) {
            Toast.shared.show(message: String(localized: "Error: \(message)"), type: .error)
        } catch {
            print(error)
            Toast.shared.show(message: String(localized: "An unexpected error occurred"), type: .error)
        }
    }
    
    var searchedReportOverview: MapExplorerReport?
    
    func searchReport(by id: String) async {
        do {
            let result = try await MapExplorerRepository.shared.report(id, countryCode: .SV, cityId: "")
            self.searchedReportOverview = result
            
            if let authViewModel = authViewModel {
                authViewModel.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: result.clLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
                    )
                )
            }
        } catch CommonIntercommunicationErrors.invalidPetition(let code) {
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "Invalid request (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.notFound {
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "Report not found"), type: .error)
        } catch CommonIntercommunicationErrors.serverError(let code) {
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "Server error (\(code))"), type: .error)
        } catch CommonIntercommunicationErrors.networkError(let message) {
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "Network error: \(message)"), type: .error)
        } catch CommonIntercommunicationErrors.genericError(let message) {
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "Error: \(message)"), type: .error)
        } catch {
            print("Failed to fetch report overview: \(error)")
            self.searchedReportOverview = nil
            Toast.shared.show(message: String(localized: "An unexpected error occurred"), type: .error)
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
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.009769149244501563,
                        longitudeDelta: 0.006849679212379556
                    )
                )
            )
            
            Task {
                await self.loadReportsWith(coordinate)
            }
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
        
        print("[CAMERA POSITION]: \(authViewModel.cameraPosition.region?.center.latitude ?? 0), \(authViewModel.cameraPosition.region?.center.longitude ?? 0)")
        
        Task {
            await loadReportsWith(location.coordinate)
        }
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
    let manager = CLLocationManager()
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
