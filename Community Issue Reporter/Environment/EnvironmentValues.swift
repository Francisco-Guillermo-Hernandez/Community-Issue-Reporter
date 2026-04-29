//
//  EnvironmentValues.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import SwiftUI

@Observable
final class SettingsStore {
    
    static let shared = SettingsStore()

    var geographicalRegion: Int {
        didSet { UserDefaults.standard.set(geographicalRegion, forKey: "geographicalRegion") }
    }
    
    var selectedCountry: Int {
        didSet { UserDefaults.standard.set(selectedCountry, forKey: "selectedCountry") }
    }
    
    var selectedState: Int {
        didSet { UserDefaults.standard.set(selectedState, forKey: "selectedState") }
    }
    
    var selectedCity: Int {
        didSet { UserDefaults.standard.set(selectedCity, forKey: "selectedCity") }
    }
    
    var enableBackgroundSync: Bool {
        didSet { UserDefaults.standard.set(enableBackgroundSync, forKey: "enableBackgroundSync") }
    }
    
    var enableAnonymousTelemetry: Bool {
        didSet { UserDefaults.standard.set(enableAnonymousTelemetry, forKey: "enableAnonymousTelemetry") }
    }
    
    var selectedLanguageID: Int {
        didSet { UserDefaults.standard.set(selectedLanguageID, forKey: "selectedLanguageID") }
    }
    
    var selectedLanguageCode: String {
        didSet { UserDefaults.standard.set(selectedLanguageCode, forKey: "selectedLanguageCode") }
    }
    
    var enableAutomaticIdentification: Bool {
        didSet { UserDefaults.standard.set(enableAutomaticIdentification, forKey: "enableAutomaticIdentification") }
    }
    
    var enableNotifications: Bool {
        didSet { UserDefaults.standard.set(enableNotifications, forKey: "enableNotifications") }
    }
    
    init () {
        self.geographicalRegion = UserDefaults.standard.object(forKey: "geographicalRegion") as? Int ?? 2
        self.selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? Int ?? 2
        self.selectedState = UserDefaults.standard.object(forKey: "selectedState") as? Int ?? 0
        self.selectedCity = UserDefaults.standard.object(forKey: "selectedCity") as? Int ?? 0
        self.enableBackgroundSync = UserDefaults.standard.object(forKey: "enableBackgroundSync") as? Bool ?? true
        self.enableAnonymousTelemetry = UserDefaults.standard.object(forKey: "enableAnonymousTelemetry") as? Bool ?? false
        self.selectedLanguageID = UserDefaults.standard.object(forKey: "selectedLanguageID") as? Int ?? 1
        self.selectedLanguageCode = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? "es-419"
        self.enableAutomaticIdentification = UserDefaults.standard.object(forKey: "enableAutomaticIdentification") as? Bool ?? false
        self.enableNotifications = UserDefaults.standard.object(forKey: "enableNotifications") as? Bool ?? false
        
        UserDefaults.standard.register(defaults: [
            "geographicalRegion": 2,
            "selectedCountry": 2,
            "selectedState": 0,
            "selectedCity": 0,
            "enableBackgroundSync": true,
            "enableAnonymousTelemetry": false,
            "selectedLanguageID": 1,
            "selectedLanguageCode": "es-419",
            "enableAutomaticIdentification": false,
            "enableNotifications": false,
        ])
    }
    
    var region: GeographicalRegion {
        return geographicalRegions.first(where: { $0.id == geographicalRegion })!
    }
    
    var country: Country? {
        return region.countries.first(where: { $0.id == selectedCountry })
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
