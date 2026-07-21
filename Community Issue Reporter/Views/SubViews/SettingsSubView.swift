//
//  SettingsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct FooterText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(Font.footnote)
            .fontWeight(.regular)
            .foregroundStyle(.secondary)
            .padding(.leading, .themeSpacing * 4.5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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
    @Environment(\.isEnabled) var isEnabled
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
                    .opacity(isEnabled ? 1 : 0.5)
                VStack {
                    VStack(spacing: .themeSpacing * 4) {
                        content
                            .opacity(isEnabled ? 1 : 0.5)
                    }
                    .padding()
                }
                .customCardStyle()
                
                if let text = footerText {
                    FooterText(text: text)
                        .opacity(isEnabled ? 1 : 0.5)
                }
            }
            
        }
    }
}

import MapKit
import SwiftUI

struct SettingsSubView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var settings = SettingsStore.shared
    @EnvironmentObject var appState: AuthViewModel
    @Environment(NetworkMonitor.self) var networkMonitor
    
    @State private var geographicalRegion: Int = 1
    @State private var countries: [Country] = []
    @State private var regions: [Region] = []
    
    @State private var cities: [FriendlyCityDistribution] = []
    
    @Environment(NotificationManager.self) var notificationManager
    @State private var controller: SettingsSubViewController
    
    init(subViewName: String) {
        self.subViewName = subViewName
        controller = SettingsSubViewController()
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
                                    Text(controller.selectedCity.thirdLevel)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                    .disabled(!networkMonitor.isConnected)
                    
                    SettingsGroup(
                        title: String(localized: "Privacy"),
                        footerText: String(localized: "You can show or hide your profile and your username when you share your reports and petitions with others.")
                    ) {
                        Toggle("Show my profile", isOn: $settings.showMyProfile)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyProfile) { oldValue, newValue in
                                controller.updatePrivacySettings()
                            }
                        
                        Toggle(String(localized: "Show my user name when I share"), isOn: $settings.showMyUseNameWhenShare)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyUseNameWhenShare) { oldValue, newValue in
                                controller.updatePrivacySettings()
                            }
                    }
                    .disabled(!networkMonitor.isConnected)
                    
                    /// Notifications group
                    SettingsGroup(title: String(localized: "Notifications")) {
                        Toggle("Push notifications", isOn: $settings.enablePushNotifications)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.enablePushNotifications) { oldValue, newValue in
                                controller.updateNotificationSettings()
                                
                                if !notificationManager.isPermissionGranted {
                                    notificationManager.requestAuthorization()
                                }
                                
                            }
                            .onChange(of: notificationManager.isPermissionGranted) { oldValue, newValue in
                                if oldValue != newValue && !notificationManager.deviceToken.isEmpty {
                                    controller.updateDeviceToken()
                                }
                            }
                        
                        Toggle("Email notifications", isOn: $settings.enableEmailNotifications)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.enableEmailNotifications) { oldValue, newValue in
                                controller.updateNotificationSettings()
                            }
                    }
                    .disabled(!networkMonitor.isConnected)
                    
                    SettingsGroup(title: String(localized: "App settings")) {
                        
                        Toggle("Save last location", isOn: $settings.saveLastLocation)
                            .foregroundStyle(Color.theme.inputText)
                        
                        
                        Toggle("Use my current location", isOn: $settings.useMyCurrentLocation)
                            .foregroundStyle(Color.theme.inputText)
                        
                        Toggle("Anonymous telemetry", isOn: $settings.enableAnonymousTelemetry)
                            .foregroundStyle(Color.theme.inputText)
                        
                    }
                    .disabled(!networkMonitor.isConnected)
                }
            }
            .padding(.horizontal)
            .background(Color.theme.background)
            .task {
                guard let documents = CitiesRepository.shared.loadLocalCities(of: .SV).documents
                else { return }
                
                cities = documents
                
                /// Inject dependencies
                controller.inject(self.settings, self.notificationManager)
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listSectionSpacing(32)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle(subViewName)
            .task {
                
                if let savedCity = appState.selectedCity {
                    controller.selectedCity = savedCity
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
            countryCode: settings.countryCodeIso,
            mode: .modify,
            selectedCity: $controller.selectedCity,
            nextStep: {
                appState.selectedCity = controller.selectedCity
                
                let span = MKCoordinateSpan(
                    latitudeDelta: 0.0022298826163122953,
                    longitudeDelta: 0.0014447804127257768
                )
                
                appState.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: controller.selectedCity.coordinates.lat,
                            longitude: controller.selectedCity.coordinates.lng
                        ),
                        span: span
                    )
                )
                
                dismiss()
            }
        )
    }
    
}

#Preview {
    SettingsSubView(subViewName: "Settings")
        .environmentObject(AuthViewModel())
        .environment(NotificationManager())
        .environment(SettingsStore())
        .environment(NetworkMonitor())
}
