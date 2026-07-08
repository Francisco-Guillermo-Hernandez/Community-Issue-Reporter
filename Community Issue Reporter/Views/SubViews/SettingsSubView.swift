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
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settings: SettingsStore
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
                    SettingsGroup(title: String(localized: "Location")) {
                        
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
                            }
                        }
                    }
                    
                    SettingsGroup(title: String(localized: "Privacy"), footerText: "") {
                        Toggle("Show my profile", isOn: $settings.showMyProfile)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyProfile) { oldValue, newValue in
                                updatePrivacySettings()
                            }
                        
                        Toggle(String(localized: "Show my user name when I share"), isOn: $settings.showMyUseNameWhenShare)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyUseNameWhenShare) { oldValue, newValue in
                                updatePrivacySettings()
                            }
                    }
                    
                    /// Notifications group
                    SettingsGroup(title: String(localized: "Notifications")) {
                        Toggle("Push notifications", isOn: $settings.enablePushNotifications)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.enablePushNotifications) { oldValue, newValue in
                                updateNotificationSettings()
                                
                                if !notificationManager.isPermissionGranted {
                                    notificationManager.requestAuthorization()
                                }
                                
                            }
                            .onChange(of: notificationManager.isPermissionGranted) { oldValue, newValue in
                                if oldValue != newValue && !notificationManager.deviceToken.isEmpty {
                                    updateDeviceToken()
                                }
                            }
                        
                        Toggle("Email notifications", isOn: $settings.enableEmailNotifications)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.enableEmailNotifications) { oldValue, newValue in
                                updateNotificationSettings()
                            }
                    }
                    
                    SettingsGroup(title: String(localized: "App settings")) {
                        
                        Toggle("Save last location", isOn: $settings.saveLastLocation)
                            .foregroundStyle(Color.theme.inputText)
                        
                        
                        Toggle("Use my current location", isOn: $settings.useMyCurrentLocation)
                            .foregroundStyle(Color.theme.inputText)
                        
                        Toggle("Anonymous telemetry", isOn: $settings.enableAnonymousTelemetry)
                            .foregroundStyle(Color.theme.inputText)
                        
                    }
                }
            }
            .padding(.horizontal)
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
            .task {
                
                if let savedCity = appState.selectedCity {
                    self.selectedCity = savedCity
                }
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
                
                let span = MKCoordinateSpan(
                    latitudeDelta: 0.0022298826163122953,
                    longitudeDelta: 0.0014447804127257768
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
    
    func updatePrivacySettings() {
        Task {
            print("update privacy settings")
            do {
                /// Debouncing
                try await Task.sleep(for: .milliseconds(550))
                try await UserRepository.shared.privacy(
                    settings: .init(
                        showMyProfile: settings.showMyProfile,
                        showMyUseNameWhenShare: settings.showMyUseNameWhenShare
                    )
                )
            } catch {
                
            }
        }
    }
    
    func updateNotificationSettings() {
        
        print("updating")
        Task {
            try? await Task.sleep(for: .milliseconds(550))
            await UserRepository.shared.modify(.init(app: settings.enablePushNotifications, email: settings.enableEmailNotifications, web: settings.enableWebNotifications), completion: { (result: Result<String, Error>) in
                switch result {
                case .success(let message):
                    print(message)
                    
                case .failure(let error):
                    print(error)
                    
                }
            })
        }
    }
    
    func updateDeviceToken() {
        
        Task {
            
            do {
                _ = try await UserRepository.shared.sendDevice(notificationManager.deviceToken)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SettingsSubView(subViewName: "Settings")
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationManager())
        .environmentObject(SettingsStore())
}
