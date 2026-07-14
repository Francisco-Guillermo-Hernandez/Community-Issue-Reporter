//
//  AuthViewModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 5/4/26.
//

import Foundation
internal import Combine
import GoogleSignIn
import MapKit
import SwiftUI

class AuthViewModel: ObservableObject {
    
    static let shared = AuthViewModel()
    
    @Published var userProfile: UserProfile?
    @Published var user: GIDGoogleUser?
    @Published var isLoggedIn = false
    @Published var isCheckingStatus = true
    @Published var isGuestUser: Bool = false
    @Published var landingViewMode: Bool = false
    @Published var selectedCity: FriendlyCityDistribution? {
        didSet {
            saveCityToUserDefaults()
        }
    }
    
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.86634819078747, longitude:-89.85026973265276),
            span: MKCoordinateSpan(latitudeDelta: 0.016837009321045926, longitudeDelta:  0.016440700713786782)
        )
    )

    init() {
        loadCityFromUserDefaults()
        setupInitialCameraPosition()
    }
    
    func setCameraPosition(to position: Coordinate, latitudeDelta: Double, longitudeDelta: Double) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: position.locationCoordinate,
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        )
    }
    
    func setupInitialCameraPosition() {
        if let city = selectedCity {
            let latDelta = UserDefaults.standard.double(forKey: "map_latitude_delta")
            let lonDelta = UserDefaults.standard.double(forKey: "map_longitude_delta")
            
            let span = (latDelta != 0 && lonDelta != 0) ?
                MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta) :
                MKCoordinateSpan(latitudeDelta: 0.016837009321045926, longitudeDelta: 0.016440700713786782)

            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: city.coordinates.lat, longitude: city.coordinates.lng),
                    span: span
                )
            )
        }
    }

    private func saveCityToUserDefaults() {
        if let selectedCity = selectedCity {
            if let encoded = try? JSONEncoder().encode(selectedCity) {
                UserDefaults.standard.set(encoded, forKey: "selected_city")
            }
        }
    }

    private func loadCityFromUserDefaults() {
        if let savedCityData = UserDefaults.standard.data(forKey: "selected_city") {
            if let decodedCity = try? JSONDecoder().decode(FriendlyCityDistribution.self, from: savedCityData) {
                self.selectedCity = decodedCity
            }
        }
    }

    @MainActor
    func checkStatus() async {
        isCheckingStatus = true 
        
        defer {
            isCheckingStatus = false
        }
        
        do {
            /// GIDSignIn throws an error if the sign-in can't be restored
            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            self.user = user
            self.isLoggedIn = true
        } catch {
            self.user = nil
            self.isLoggedIn = false
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
        
        DispatchQueue.main.async {
            self.user = nil
            self.isLoggedIn = false
            self.userProfile = nil
            
            _ = KeychainService.deleteToken(key: .query)
            _ = KeychainService.deleteToken(key: .mutation)
            _ = KeychainService.deleteToken(key: .sessionStateVerification)
            
//            UserDefaults.standard.set(nil, forKey: "selected_city")
            
            let selectedOptionKey = "selected_avatar_option"
            let selectedColorKey = "selected_avatar_color"
            UserDefaults.standard.set(nil, forKey: selectedOptionKey)
            UserDefaults.standard.set(nil, forKey: selectedColorKey)
            UserDefaults.standard.set(nil, forKey: "map_latitude_delta")
            UserDefaults.standard.set(nil, forKey: "map_longitude_delta")
            UserDefaults.standard.set(nil, forKey: "avatar_url")
            UserDefaults.standard.set(nil, forKey: "user_name")
            UserDefaults.standard.set(nil, forKey: "selectedLanguageCode")
        }
    }
    
}
