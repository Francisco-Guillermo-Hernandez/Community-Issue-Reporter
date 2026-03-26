//
//  EnvironmentValues.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import SwiftUI

@Observable
class Store {
    var geographicalRegion: Int {
        get { UserDefaults.standard.integer(forKey: "geographicalRegion") }
        set { UserDefaults.standard.set(newValue, forKey: "geographicalRegion") }
    }
    
    var selectedCountry: Int {
        get { UserDefaults.standard.integer(forKey: "selectedCountry") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedCountry") }
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
    
    init () {
        UserDefaults.standard.register(defaults: [
            "geographicalRegion": 1,
            "selectedCountry": 0,
            "enableBackgroundSync": true,
            "enableAnonymousTelemetry": false,
            "selectedLanguage": 1,
            "enableAutomaticIdentification": false
        ])
    }
}

struct StoreKey: EnvironmentKey {
    static var defaultValue = Store()
}

extension EnvironmentValues {
    var mySettings: Store {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}
