//
//  SettingsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct SettingsSubView: View {


    @Environment(\.mySettings) private var settings

    @State private var geographicalRegion: Int = 1
    @State private var selectedCountry: Int = 0
    @State private var enableBackgroundSync: Bool = true
    @State private var enableAnonymousTelemetry: Bool = false
    @State private var selectedLanguage: Int = 1
    @State private var enableAutomaticIdentification: Bool = true

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
                        
                        settings.geographicalRegion = newValue
                    }

                    ///
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(getCountries(geographicalRegion: geographicalRegion), id: \.id) { item in
                            Text(item.name).tag(item.id)
                        }
                    }
                    .onChange(of: selectedCountry) { _, newValue in
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
                        settings.selectedLanguage = newValue
                    }
                    
                    Toggle("Background sync", isOn: $enableBackgroundSync)
                        .onChange(of: enableBackgroundSync) { _, newValue in
                            settings.enableBackgroundSync = newValue
                        }
                    
                    Toggle("Anonymous telemetry", isOn: $enableAnonymousTelemetry)
                        .onChange(of: enableAnonymousTelemetry) { _, newValue in
                            settings.enableAnonymousTelemetry = newValue
                        }
                    
                    Toggle("Automatic identification", isOn: $enableAutomaticIdentification)
                        .onChange(of: enableAutomaticIdentification) { _, newValue in
                            settings.enableAutomaticIdentification = newValue
                        }
                    
                } header: {
                    Text("App settings")
                } footer: {
                    Text("")
                }
            }
            .listSectionSpacing(32)
            .onAppear {
                geographicalRegion = settings.geographicalRegion
                selectedCountry = settings.selectedCountry
                enableBackgroundSync = settings.enableBackgroundSync
                enableAnonymousTelemetry = settings.enableAnonymousTelemetry
                selectedLanguage = settings.selectedLanguage
                enableAutomaticIdentification = settings.enableAutomaticIdentification
            }
        }
        .navigationTitle(subViewName)
        .toolbarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(true)
    }
    
    func getCountries(geographicalRegion: Int) -> [Country] {
        return geographicalRegions.first(where: { $0.id == geographicalRegion })?.countries ?? []
    }
}

#Preview {
    SettingsSubView(subViewName: "Settings")
}
