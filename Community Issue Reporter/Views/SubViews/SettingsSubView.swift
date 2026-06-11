//
//  SettingsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct SettingsHeaderView: View {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, .themeSpacing * 4.5)
            .foregroundStyle(.secondary)
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String
    let footerText: String?
    let content: Content

    // @ViewBuilder allows the closure to construct views implicitly
    init(title: String, footerText: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.footerText = footerText
        self.content = content()
    }

    var body: some View {
        Group {
            VStack(spacing: .themeSpacing * 1.5) {
                
                SettingsHeaderView(title)
                VStack {
                    VStack(spacing: .themeSpacing * 4) {
                        content
                    }
                    .padding()
//                    .padding(.bottom, 8)
//                    .padding(.top, 8)
                }
                .customCardStyle()
                
                if let footerText = footerText {
                    Text(footerText)
                        .font(Font.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                        .padding(.leading, .themeSpacing * 4.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
        }
    }
}

import MapKit
import SwiftUI

struct SettingsSubView: View {

    @Environment(\.mySettings) private var settings
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AuthViewModel

    @State private var geographicalRegion: Int = 1
    @State private var selectedCountry: Int = 0
    @State private var enableBackgroundSync: Bool = false
    @State private var enableAnonymousTelemetry: Bool = true
    @State private var selectedLanguage: Int = 1
    @State private var enableAutomaticIdentification: Bool = true

    @State private var countries: [Country] = []
    @State private var regions: [Region] = []
    @State private var cities: [FriendlyCityDistribution] = []
    @State private var language: String = "es-419"
    @State private var enableNotifications: Bool = false
    @State private var saveLastLocation: Bool = true
    @State private var useMyCurrentLocation: Bool = false
    
    
    @EnvironmentObject var notificationManager: NotificationManager
    
     @State private var textToCopy = "Hello, World!"
        @State private var showCopiedMessage = false
    
    @State var notifications: Notifications = .init(app: false, email: false, web: false)

    @State private var selectedCity: FriendlyCityDistribution = .init(
        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
        firstLevel: "El Salvador",
        secondLevel: "San Salvador",
        thirdLevel: "San Salvador",
        ZipCode: "1101",
        legalGroupName: "Distrito de San Salvador",
        coordinates: .init(lat: 13.701270, lng: -89.224432),
        isCapitalCity: 1,
        isDepartmentalCapital: 1
    )
    
    init(subViewName: String) {
        self.subViewName = subViewName
    }

    var subViewName: String
    var body: some View {
        NavigationStack {
            
            ScrollView() {
                
                VStack(spacing: .themeSpacing * 8) {
                    /// Location group
                    SettingsGroup(title: "Location") {
//                        HStack {
//                            Text("Region")
//                            Spacer()
//                            Picker("Region", selection: $geographicalRegion) {
//                                ForEach(geographicalRegions, id: \.id) { item in
//                                    Text(item.name).tag(item.id)
//                                }
//                            }
//                            
//                            .onChange(of: geographicalRegion) { _, newValue in
//                                if settings.geographicalRegion != newValue {
//                                    selectedCountry = 0
//                                }
//
//                                countries = getCountries(geographicalRegion: newValue)
//                                settings.geographicalRegion = newValue
//                            }
//    //                        .disabled(true)
//                        }
//

                        ///
//                        HStack {
//                            Text("Country")
//                            Spacer()
//                            Picker("Country", selection: $selectedCountry) {
//                                ForEach(countries, id: \.id) { item in
//                                    Text(item.name).tag(item.id)
//                                }
//                            }
//                            .onChange(of: selectedCountry) { _, newValue in
//
//                                regions = getRegion(countryId: newValue)
//                                settings.selectedCountry = newValue
//                            }
//    //                        .disabled(true)
//                        }
//                        .hidden()

                        NavigationLink(destination: selectCityView()) {
                            HStack {
                                Text("City")
                                    .foregroundStyle(Color.theme.inputText)
                                   
                                Spacer()
                                HStack(spacing: 4) {
                                    Text(selectedCity.thirdLevel)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                }
//                                .padding(.trailing, 14)
//                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    
                    /// Notifications group
                    SettingsGroup(title: "Notifications") {
                        Toggle("Push notifications", isOn: $notifications.app)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: notifications.app) { oldValue, newValue in
                                if oldValue != newValue {
                                    settings.enablePushNotifications = newValue
                                    updateNotificationSettings()
                                    
                                }
                            }
                        
                        Toggle("Email notifications", isOn: $notifications.email)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: notifications.email) { oldValue, newValue in
                                if oldValue != newValue {
                                    settings.enableEmailNotifications = newValue
                                    updateNotificationSettings()
                                }
                            }
                    }
                    
                    SettingsGroup(title: "App settings") {
                        
                        Toggle("Save last location", isOn: $saveLastLocation)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: saveLastLocation) { _, newValue in
                                settings.saveLastLocation = newValue
                            }
                        
                        Toggle("Use my current location", isOn: $useMyCurrentLocation)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: useMyCurrentLocation) { _, newValue in
                                settings.useMyCurrentLocation = newValue
                            }
                        
                        Toggle("Anonymous telemetry", isOn: $enableAnonymousTelemetry)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: enableAnonymousTelemetry) { _, newValue in
                                settings.enableAnonymousTelemetry = newValue
                            }
                    }
                    
                    
                    Button(action: {
                                        
                                        textToCopy = notificationManager.isPermissionGranted ? notificationManager.deviceToken : ""
                                                   // 1. Copy the text string to the system clipboard
                                                   UIPasteboard.general.string = textToCopy
                                                   
                                                   // 2. Provide visual feedback
                                                   withAnimation {
                                                       showCopiedMessage = true
                                                   }
                                                   
                                                   // Hide feedback after 2 seconds
                                                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                       withAnimation {
                                                           showCopiedMessage = false
                                                       }
                                                   }
                                               }) {
                                                   Label("Copy to Clipboard", systemImage: "doc.on.doc")
                                               }
                                               .buttonStyle(.borderedProminent)

                                               if showCopiedMessage {
                                                   Text("Copied! 🎉")
                                                       .foregroundColor(.green)
                                                       .transition(.opacity)
                                               }
                    
                    Button("Enable") {
                                       notificationManager.requestAuthorization()
                                   }
                                   
                                   VStack(spacing: 20) {
                                            Text(notificationManager.isPermissionGranted ? "Notifications Enabled ✅" : "Notifications Disabled ❌")
                                            
                                            if !notificationManager.deviceToken.isEmpty {
                                                Text("Your APNs Device Token:")
                                                    .font(.caption)
                                                Text(notificationManager.deviceToken)
                                                    .font(.system(.caption2, design: .monospaced))
                                                    .padding()
                                                    .background(Color(.systemGray6))
                                            }
                                        }
                                        .padding()
                }
                
            }
            .padding(.horizontal)
            
//            List {
//                Section {
//                    ///

//
//                } header: {
//                    Text("Where I from?")
//                } footer: {
//                    Text(
//                        "It's important to know where you are from in order to show and report issues to the right people "
//                    )
//                }
//                
//                
//
//                
//                Section {
//                   
//                } header: {
//                    Text(String(localized: "Notifications"))
//                } footer: {
//                    Text("")
//                }
//                
//           
////                .padding()
//                
//                Section {
//
//                    Picker("Language", selection: $selectedLanguage) {
//                        ForEach(langs, id: \.id) { item in
//                            Text(item.name).tag(item.id)
//                        }
//                    }
//                    .onChange(of: selectedLanguage) { _, newValue in
//                        settings.selectedLanguageID = newValue
//                        if let lang = langs.first(where: { $0.id == newValue }) {
//                            settings.selectedLanguageCode = lang.code
//                        }
//                    }
//
//
//
//                    Toggle("Background sync", isOn: $enableBackgroundSync)
//                        .disabled(true)
//                        .onChange(of: enableBackgroundSync) { _, newValue in
//                            settings.enableBackgroundSync = newValue
//                        }
//
//
//
//                    Toggle("Automatic identification", isOn: $enableAutomaticIdentification)
//                    .disabled(true)
//                    .onChange(of: enableAutomaticIdentification) {
//                        _,
//                        newValue in
//                        settings.enableAutomaticIdentification = newValue
//                    }
//
//                    Toggle("Notifications", isOn: $enableNotifications)
//                        .onChange(of: enableNotifications) { _, newValue in
//
//                        }
//
//                } header: {
//                    Text("App settings")
//                } footer: {
//                    Text("")
//                }
//                
//                
//
//            }
//            .listStyle(.plain)
            .background(Color.theme.background)
            .task {
                guard let documents = CitiesRepository.shared.loadLocalCities(of: .SV).documents
                else { return }
                
                cities = documents
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listSectionSpacing(32)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle(subViewName)
            .onAppear {
                geographicalRegion = settings.geographicalRegion
                selectedCountry = settings.selectedCountry
                //                selectedCity = settings.selectedCity
                enableBackgroundSync = settings.enableBackgroundSync
                enableAnonymousTelemetry = settings.enableAnonymousTelemetry
                selectedLanguage = settings.selectedLanguageID
                enableAutomaticIdentification =
                    settings.enableAutomaticIdentification
                enableNotifications = settings.enableNotifications
                saveLastLocation = settings.saveLastLocation
                useMyCurrentLocation = settings.useMyCurrentLocation

                if let savedCity = appState.selectedCity {
                    self.selectedCity = savedCity
                }

                countries = getCountries(geographicalRegion: geographicalRegion)
                
                notifications.email = settings.enableEmailNotifications
                notifications.app = settings.enablePushNotifications
            }
        }

        .background(Color.theme.background)
        .interactiveDismissDisabled(true)

    }

    func getCountries(geographicalRegion: Int) -> [Country] {
        return geographicalRegions.first(where: { $0.id == geographicalRegion }
        )?.countries ?? []
    }

    func getRegion(countryId: Int) -> [Region] {
        return countries.first(where: { $0.id == countryId })?.regions ?? []
    }

    @ViewBuilder
    private func selectCityView() -> some View {
        CitySelectionView(
            countryCode: .SV,
            mode: .modify,
            selectedCity: $selectedCity,
            nextStep: {
                appState.selectedCity = selectedCity

                let latDelta = UserDefaults.standard.double(
                    forKey: "map_latitude_delta"
                )
                let lonDelta = UserDefaults.standard.double(
                    forKey: "map_longitude_delta"
                )

                let span =
                    (latDelta != 0 && lonDelta != 0)
                    ? MKCoordinateSpan(
                        latitudeDelta: latDelta,
                        longitudeDelta: lonDelta
                    )
                    : MKCoordinateSpan(
                        latitudeDelta: 0.016837009321045926,
                        longitudeDelta: 0.016440700713786782
                    )

                appState.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: selectedCity.coordinates.lat,
                            longitude: selectedCity.coordinates.lng
                        ),
                        span: span
                    )
                )

                dismiss()
            }
        )
    }

    
    func updateNotificationSettings() {
        
            print("updating")
            Task {
                try? await Task.sleep(for: .milliseconds(450))
                await UserRepository.shared.modify(notifications, completion: { (result: Result<String, Error>) in
                    switch result {
                        case .success(let message):
                            print(message)
                        
                        case .failure(let error):
                            print(error)
                    
                    }
                })
            }
        }
}

#Preview {
    SettingsSubView(subViewName: "Settings")
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationManager())
}
