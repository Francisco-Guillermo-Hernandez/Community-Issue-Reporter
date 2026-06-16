//
//  EnvironmentValues.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import SwiftUI
internal import Combine
final class SettingsStore: ObservableObject {
    
    static let shared = SettingsStore()

    @Published var geographicalRegion: Int {
        didSet { UserDefaults.standard.set(geographicalRegion, forKey: "geographicalRegion") }
    }
    
    @Published var selectedCountry: Int {
        didSet { UserDefaults.standard.set(selectedCountry, forKey: "selectedCountry") }
    }
    
    @Published var countryCode: String {
        didSet { UserDefaults.standard.set(countryCode, forKey: "countryCode") }
    }
    
    @Published var cityId: String {
        didSet { UserDefaults.standard.set(cityId, forKey: "cityId") }
    }
    
    @Published var selectedState: Int {
        didSet { UserDefaults.standard.set(selectedState, forKey: "selectedState") }
    }
    
    @Published var selectedCity: Int {
        didSet { UserDefaults.standard.set(selectedCity, forKey: "selectedCity") }
    }
    
    @Published var enableBackgroundSync: Bool {
        didSet { UserDefaults.standard.set(enableBackgroundSync, forKey: "enableBackgroundSync") }
    }
    
    @Published var enableAnonymousTelemetry: Bool {
        didSet { UserDefaults.standard.set(enableAnonymousTelemetry, forKey: "enableAnonymousTelemetry") }
    }
    
    @Published var selectedLanguageID: Int {
        didSet { UserDefaults.standard.set(selectedLanguageID, forKey: "selectedLanguageID") }
    }
    
    @Published var selectedLanguageCode: String {
        didSet { UserDefaults.standard.set(selectedLanguageCode, forKey: "selectedLanguageCode") }
    }
    
    @Published var enableAutomaticIdentification: Bool {
        didSet { UserDefaults.standard.set(enableAutomaticIdentification, forKey: "enableAutomaticIdentification") }
    }
    
    @Published var enableNotifications: Bool {
        didSet { UserDefaults.standard.set(enableNotifications, forKey: "enableNotifications") }
    }
    
    @Published var enablePushNotifications: Bool {
        didSet { UserDefaults.standard.set(enablePushNotifications, forKey: "enablePushNotifications") }
    }
    
    @Published var enableEmailNotifications: Bool {
        didSet { UserDefaults.standard.set(enableEmailNotifications, forKey: "enableEmailNotifications") }
    }
    
    @Published var enableWebNotifications: Bool {
        didSet { UserDefaults.standard.set(enableWebNotifications, forKey: "enableEmailNotifications") }
    }
    
    @Published var saveLastLocation: Bool {
        didSet { UserDefaults.standard.set(saveLastLocation, forKey: "saveLastLocation") }
    }
  
    @Published var useMyCurrentLocation: Bool {
        didSet { UserDefaults.standard.set(useMyCurrentLocation, forKey: "useMyCurrentLocation") }
    }
    
    @Published var showMyProfile: Bool {
        didSet { UserDefaults.standard.set(showMyProfile, forKey: "showMyProfile") }
    }
    
    @Published var showMyUseNameWhenShare: Bool {
        didSet { UserDefaults.standard.set(showMyUseNameWhenShare, forKey: "showMyUseNameWhenShare") }
    }
    
    init () {

        self.geographicalRegion = UserDefaults.standard.object(forKey: "geographicalRegion") as? Int ?? 2
        self.selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? Int ?? 2
        self.selectedState = UserDefaults.standard.object(forKey: "selectedState") as? Int ?? 0
        self.selectedCity = UserDefaults.standard.object(forKey: "selectedCity") as? Int ?? 0
        self.countryCode = UserDefaults.standard.string(forKey: "countryCode") ?? "SV"
        self.cityId = UserDefaults.standard.string(forKey: "cityId") ?? "a67b90f9-1d76-4835-a994-03cd04f1d619"
        self.enableBackgroundSync = UserDefaults.standard.object(forKey: "enableBackgroundSync") as? Bool ?? true
        self.enableAnonymousTelemetry = UserDefaults.standard.bool(forKey: "enableAnonymousTelemetry")
        self.selectedLanguageID = UserDefaults.standard.object(forKey: "selectedLanguageID") as? Int ?? 1
        self.selectedLanguageCode = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? "es-419"
        self.enableAutomaticIdentification = UserDefaults.standard.object(forKey: "enableAutomaticIdentification") as? Bool ?? false
        self.enableNotifications = UserDefaults.standard.object(forKey: "enableNotifications") as? Bool ?? false
        self.enablePushNotifications = UserDefaults.standard.bool(forKey: "enablePushNotifications")
        self.enableEmailNotifications = UserDefaults.standard.bool(forKey: "enableEmailNotifications")
        self.saveLastLocation = UserDefaults.standard.bool(forKey: "saveLastLocation")
        self.useMyCurrentLocation = UserDefaults.standard.bool(forKey: "useMyCurrentLocation")
        self.showMyProfile = UserDefaults.standard.bool(forKey: "showMyProfile")
        self.showMyUseNameWhenShare = UserDefaults.standard.bool(forKey: "showMyUseNameWhenShare")
        self.enableWebNotifications = UserDefaults.standard.bool(forKey: "enableWebNotifications")
        
        UserDefaults.standard.register(defaults: [
            "geographicalRegion": 2,
            "selectedCountry": 2,
            "selectedState": 0,
            "selectedCity": 0,
            "enableBackgroundSync": true,
            "enableAnonymousTelemetry": true,
            "selectedLanguageID": 1,
            "selectedLanguageCode": "es-419",
            "enableAutomaticIdentification": false,
            "enableNotifications": false,
            "enableWebNotifications": false,
            "enablePushNotifications": false,
            "enableEmailNotifications": true,
            "saveLastLocation": false,
            "showMyProfile": true,
            "showMyUseNameWhenShare": true,
            "countryCode": "SV",
            "cityId": "a67b90f9-1d76-4835-a994-03cd04f1d619"
        ])
    }
    
    var region: GeographicalRegion {
        return geographicalRegions.first(where: { $0.id == geographicalRegion })!
    }
    
    var country: Country? {
        return region.countries.first(where: { $0.id == selectedCountry })
    }
    
    var countryCodeIso: CountryCode {
        return CountryCode.allCases.first(where: { $0.rawValue == countryCode }) ?? .SV
    }
}

struct StoreKey: EnvironmentKey {
    static var defaultValue = SettingsStore.shared
}

extension EnvironmentValues {
    var mySettings: SettingsStore {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}
