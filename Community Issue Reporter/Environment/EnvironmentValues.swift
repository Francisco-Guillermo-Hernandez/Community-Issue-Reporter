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
        get { UserDefaults.standard.integer(forKey: "geographicalRegion") }
        set { UserDefaults.standard.set(newValue, forKey: "geographicalRegion") }
    }
    
    var selectedCountry: Int {
        get { UserDefaults.standard.integer(forKey: "selectedCountry") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedCountry") }
    }
    
    var selectedState: Int {
        get { UserDefaults.standard.integer(forKey: "selectedState") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedState") }
    }
    
    var selectedCity: Int {
        get { UserDefaults.standard.integer(forKey: "selectedCity") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedCity") }
    }
    
    var enableBackgroundSync: Bool {
        get { UserDefaults.standard.bool(forKey: "enableBackgroundSync") }
        set { UserDefaults.standard.set(newValue, forKey: "enableBackgroundSync") }
    }
    
    var enableAnonymousTelemetry: Bool {
        get { UserDefaults.standard.bool(forKey: "enableAnonymousTelemetry") }
        set { UserDefaults.standard.set(newValue, forKey: "enableAnonymousTelemetry") }
    }
    
    var selectedLanguage: Int {
        get { UserDefaults.standard.integer(forKey: "selectedLanguage") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedLanguage") }
    }
    
    var enableAutomaticIdentification: Bool {
        get { UserDefaults.standard.bool(forKey: "enableAutomaticIdentification") }
        set { UserDefaults.standard.set(newValue, forKey: "enableAutomaticIdentification") }
    }
    
    var enableNotifications: Bool {
        get { UserDefaults.standard.bool(forKey: "enableNotifications") }
        set { UserDefaults.standard.set(newValue, forKey: "enableNotifications") }
    }
    
    init () {
        UserDefaults.standard.register(defaults: [
            "geographicalRegion": 2,
            "selectedCountry": 2,
            "selectedState": 0,
            "selectedCity": 0,
            "enableBackgroundSync": true,
            "enableAnonymousTelemetry": false,
            "selectedLanguage": 1,
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
    static var defaultValue = SettingsStore()
}

extension EnvironmentValues {
    var mySettings: SettingsStore {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}
