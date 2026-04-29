//
//  SettingsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct SettingsSubView: View {


    @Environment(\.mySettings) private var settings
    @Environment(\.dismiss) private var dismiss

    @State private var geographicalRegion: Int = 1
    @State private var selectedCountry: Int = 0
    @State private var selectedCity: Int = 0
    @State private var enableBackgroundSync: Bool = true
    @State private var enableAnonymousTelemetry: Bool = false
    @State private var selectedLanguage: Int = 1
    @State private var enableAutomaticIdentification: Bool = true

    @State private var countries: [Country] = []
    @State private var regions: [Region] = []
    @State private var cities: [City] = []
    @State private var language: String = "en"
    @State private var enableNotifications: Bool = false
    
    var subViewName: String
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                    ///
                    Picker("Region", selection: $geographicalRegion) {
                        ForEach(geographicalRegions, id: \.id) { item in
                            Text(item.name).tag(item.id)
                        }
                    }
                    .onChange(of: geographicalRegion) { _, newValue in
                        if settings.geographicalRegion != newValue {
                            selectedCountry = 0
                        }
                        
                        countries = getCountries(geographicalRegion: newValue)
                        settings.geographicalRegion = newValue
                    }

                    ///
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(countries, id: \.id) { item in
                            Text(item.name).tag(item.id)
                        }
                    }
                    .onChange(of: selectedCountry) { _, newValue in
                        
                        regions = getRegion(countryId: newValue)
                        settings.selectedCountry = newValue
                    }
                
                } header: {
                    Text("Where I from?")
                } footer: {
                    Text("It's important to know where you are from in order to show and report issues to the right people ")
                }
                
                Section {
                    
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(langs, id: \.id) { item in
                            Text(item.name).tag(item.id)
                        }
                    }
                    .onChange(of: selectedLanguage) { _, newValue in
                        settings.selectedLanguageID = newValue
                        if let lang = langs.first(where: { $0.id == newValue }) {
                            settings.selectedLanguageCode = lang.code
                        }
                    }
                    
                    Toggle("Background sync", isOn: $enableBackgroundSync)
                        .disabled(true)
                        .onChange(of: enableBackgroundSync) { _, newValue in
                            settings.enableBackgroundSync = newValue
                        }
                    
                    Toggle("Anonymous telemetry", isOn: $enableAnonymousTelemetry)
                        .disabled(true)
                        .onChange(of: enableAnonymousTelemetry) { _, newValue in
                            settings.enableAnonymousTelemetry = newValue
                        }
                    
                    Toggle("Automatic identification", isOn: $enableAutomaticIdentification)
                        .disabled(true)
                        .onChange(of: enableAutomaticIdentification) { _, newValue in
                            settings.enableAutomaticIdentification = newValue
                        }
                    
                    Toggle("Notifications", isOn: $enableNotifications)
                        .onChange(of: enableNotifications) { _, newValue in
                            
                        }
                    
                } header: {
                    Text("App settings")
                } footer: {
                    Text("")
                }
            }
            .scrollDisabled(true)
//            .scrollContentBackground(.hidden)
            .listSectionSpacing(32)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle(subViewName)
            .onAppear {
                geographicalRegion = settings.geographicalRegion
                selectedCountry = settings.selectedCountry
                selectedCity = settings.selectedCity
                enableBackgroundSync = settings.enableBackgroundSync
                enableAnonymousTelemetry = settings.enableAnonymousTelemetry
                selectedLanguage = settings.selectedLanguageID
                enableAutomaticIdentification = settings.enableAutomaticIdentification
                enableNotifications = settings.enableNotifications
                
                countries = getCountries(geographicalRegion: geographicalRegion)
            }
        }
        .interactiveDismissDisabled(true)
        
    }
    
    func getCountries(geographicalRegion: Int) -> [Country] {
        return geographicalRegions.first(where: { $0.id == geographicalRegion })?.countries ?? []
    }
    
    func getRegion(countryId: Int) -> [Region] {
        return countries.first(where: { $0.id == countryId })?.regions ?? []
    }
}

#Preview {
    SettingsSubView(subViewName: "Settings")
}
