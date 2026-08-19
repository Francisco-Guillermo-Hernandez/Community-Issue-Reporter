//
//  SettingsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI
import StoreKit

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

struct SettingsGroup<Content: View, FooterContent: View>: View {
    @Environment(\.isEnabled) var isEnabled
    let title: String
    let footerText: String?
    let content: Content
    let footerContent: FooterContent?
    
    // Primary initializer supporting both content closures
    init(
        title: String,
        footerText: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footerContent: () -> FooterContent
    ) {
        self.title = title
        self.footerText = footerText
        self.content = content()
        self.footerContent = footerContent()
    }
    
    // Convenience initializer when no footerContent is provided
    init(
        title: String,
        footerText: String? = nil,
        @ViewBuilder content: () -> Content
    ) where FooterContent == EmptyView {
        self.title = title
        self.footerText = footerText
        self.content = content()
        self.footerContent = nil
    }
    
    var body: some View {
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
            
            if let footerContent {
                VStack(spacing: .themeSpacing * 4) {
                    footerContent
                        .padding(.leading, .themeSpacing * 2)
                }
            }
        }
    }
}


import MapKit
import SwiftUI
import RevenueCat
import RevenueCatUI

struct SettingsSubView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var settings = SettingsStore.shared
    @State private var router = DeepLinkRouter.shared
    @EnvironmentObject var appState: AuthViewModel
    @Environment(NetworkMonitor.self) var networkMonitor
    
    @State private var geographicalRegion: Int = 1
    @State private var countries: [Country] = []
    @State private var regions: [Region] = []
    
    @State private var cities: [FriendlyCityDistribution] = []
    
    @Environment(NotificationManager.self) var notificationManager
    @Environment(SubscriptionManager.self) var subscriptionManager
    @State private var isPresentingPaywall = false
    @State private var isPresentingCustomerCenter = false
    @State private var controller: SettingsSubViewController
    @State private var landingController = LandingController.shared
    
    init(subViewName: String) {
        self.subViewName = subViewName
        controller = SettingsSubViewController()
    }
    
    var subViewName: String
    var body: some View {
        Group {
            
            ScrollView(showsIndicators: true) {
                
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
                    
                    /// Subscription group
                    SettingsGroup(
                        title: String(localized: "Subscription"),
                        footerText: String(localized: "You can help us to improve the app by supporting us.")) {
                            if subscriptionManager.isPro {
                                HStack {
                                    Text("Reportamelo Pro")
                                        .foregroundStyle(Color.green)
                                    Spacer()
                                    Text("Active")
                                        .foregroundStyle(.secondary)
                                }
                                
                                Button(action: {
                                    isPresentingCustomerCenter = true
                                }) {
                                    Text(String(localized: "Manage Subscription"))
                                        .foregroundStyle(Color.accentColor)
                                }
                            } else {
                                Button(action: {
                                    isPresentingPaywall = true
                                }) {
                                    HStack {
                                        Text("Reportamelo Pro")
                                            .foregroundStyle(Color.theme.inputText)
                                        Spacer()
                                        Text("Upgrade")
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                                .accessibilityIdentifier("UpgradeSubscriptionButton")
                                
                                Divider()
                                    .opacity(0.67)

                                Button(action: {
                                    Task {
                                        let success = await subscriptionManager.restorePurchases()
                                        if success {
                                            if subscriptionManager.isPro {
                                                Toast.shared.show(message: String(localized: "Purchases restored successfully"), type: .success)
                                            } else {
                                                Toast.shared.show(message: String(localized: "No active subscription found to restore"), type: .error)
                                            }
                                        } else {
                                            Toast.shared.show(message: String(localized: "Failed to restore purchases"), type: .error)
                                        }
                                    }
                                }) {
                                    HStack {
                                        Text("Do you have a subscription?")
                                            .foregroundStyle(Color.theme.inputText)
                                        Spacer()
                                        Text("Restore")
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                                .accessibilityIdentifier("RestoreSubscriptionButton")
                            }
                        }
                        .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
                    SettingsGroup(
                        title: String(localized: "Privacy"),
                        footerText: String(localized: "You can show or hide your profile and your username when you share your reports and petitions with others.")
                    ) {
                        Toggle("Show my profile", isOn: $settings.showMyProfile)
                            .tint(Color.theme.primary)
                            .accessibilityIdentifier("ShowMyProfileToggle")
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyProfile) { oldValue, newValue in
                                controller.updatePrivacySettings()
                            }
                        
                        Divider()
                            .opacity(0.67)
                        
                        Toggle(String(localized: "Show my user name when I share"), isOn: $settings.showMyUseNameWhenShare)
                            .accessibilityIdentifier("ShowMyUserNameWhenShareToggle")
                            .tint(Color.theme.primary)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.showMyUseNameWhenShare) { oldValue, newValue in
                                controller.updatePrivacySettings()
                            }
                    }
                    .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
                    /// Notifications group
                    SettingsGroup(title: String(localized: "Notifications"),
                                  footerText: String(localized: "You can enable or disable push notifications in order to receive updates when authorities are resolving your report or petition.")) {
                        Toggle("Push notifications", isOn: $settings.enablePushNotifications)
                            .accessibilityIdentifier("PushNotificationsToggle")
                            .tint(Color.theme.primary)
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
                        
                        Divider()
                            .opacity(0.67)

                        Toggle("Email notifications", isOn: $settings.enableEmailNotifications)
                            .accessibilityIdentifier("EmailNotificationsToggle")
                            .tint(Color.theme.primary)
                            .foregroundStyle(Color.theme.inputText)
                            .onChange(of: settings.enableEmailNotifications) { oldValue, newValue in
                                controller.updateNotificationSettings()
                            }
                    }
                                  .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
                    SettingsGroup(
                        title: String(localized: "App settings")
                    ) {
                        
                        Toggle("Save last location", isOn: $settings.saveLastLocation)
                            .accessibilityIdentifier("SaveLastLocationToggle")
                            .tint(Color.theme.primary)
                            .foregroundStyle(Color.theme.inputText)

                        Divider()
                            .opacity(0.67)
                        
                        Toggle("Use my current location", isOn: $settings.useMyCurrentLocation)
                            .accessibilityIdentifier("UseMyCurrentLocationToggle")
                            .tint(Color.theme.primary)
                            .foregroundStyle(Color.theme.inputText)
                        
                        Divider()
                            .opacity(0.67)
                        
                        Toggle("Anonymous telemetry", isOn: $settings.enableAnonymousTelemetry)
                            .accessibilityIdentifier("AnonymousTelemetryToggle")
                            .tint(Color.theme.primary)
                            .foregroundStyle(Color.theme.inputText)
                        
                    } footerContent: {
                        LinksView(type: .privacy)
                    }
                    .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
//                    SettingsGroup(title: String(localized: "Community")) {
//                        NavigationLink(destination: ReportsAndViolationsCenterView()) {
//                            HStack {
//                                Text(String(localized: "Reports and violations center"))
//                                    .foregroundStyle(Color.theme.inputText)
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                    }
//                    .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
                    
                    SettingsGroup(
                        title: String(localized: "Dangerous zone"),
                        footerText: String(localized: "Once your account is deleted, there is no going back.")
                    ) {
                        
                        VStack(spacing: .themeSpacing * 4) {
                            Text(String(localized: "You have control over your data and you can opt to delete your account at any time."))
                                .foregroundStyle(Color.theme.inputText)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(localized: "If your are using Login with Apple you have to revoke the access to your account from Apple to delete your access to this app."))
                                .foregroundStyle(Color.theme.inputText)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ThemedButton(
                                message: String(localized: "Delete my account"),
                                action: {
                                    
                                    controller.handleDeleteRequest(isPro: subscriptionManager.isPro)
                                },
                                type: .danger,
                                isLoading: $controller.isDeletingAccount,
                            )
                            .accessibilityIdentifier("DeleteAccountButton")
                            /// The Interceptor Alert
                            .alert(String(localized: "You have an active subscription"), isPresented: $controller.showActiveSubscriptionAlert) {
                                Button(String(localized: "Manage Subscriptions")) {
                                    /// Triggers RevenueCat's fallback-safe manager
                                    Task {
                                        do {
                                            try await Purchases.shared.showManageSubscriptions()
                                        } catch {
                                            print("Failed to show manage subscriptions: \(error)")
                                        }
                                    }
                                }
                                Button(String(localized: "Delete anyway"), role: .destructive) {
                                    /// If they insist on deleting without canceling, proceed
                                    controller.showDeleteAlert = true
                                }
                                
                                Button(String(localized: "Cancel"), role: .cancel) {}
                                
                            } message: {
                                Text(String(localized: "You currently have an active Reportamelo Pro subscription. Deleting your account will NOT stop your monthly App Store billing. Please cancel your subscription first."))
                            }
                            .alert(String(localized: "Delete Account"), isPresented: $controller.showDeleteAlert) {
                                Button(String(localized: "Cancel"), role: .cancel) { }
                                Button(String(localized: "Delete"), role: .destructive) {
                                    Task {
                                        await controller.deleteAccount()
                                        appState.logout()
                                        dismiss()
                                        landingController.logout()
                                        landingController.accountDeleted = true
                                    }
                                }
                            } message: {
                                Text(String(localized: "Are you sure you want to permanently delete your account? This action cannot be undone."))
                            }
                        }
                        .padding(.bottom, 2)
                        
                        
                    }
                    .disabled(!networkMonitor.isConnected || UserRepository.shared.isGuestUser())
                    
                    /// About
                    SettingsGroup(title: String(localized: "About")) {
                        HStack {
                            Text(String(localized: "Version"))
                                .foregroundStyle(Color.theme.inputText)
                            Spacer()
                            Text("v1.0.0")
                                .font(.system(.caption, design: .monospaced))
                                .kerning(0.69)
                                .textSelection(.enabled)
                                .foregroundStyle(Color.theme.inputText)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text(String(localized: "Commit"))
                                .foregroundStyle(Color.theme.inputText)
                            Spacer()
                            Text("8466b51")
                                .font(.system(.caption, design: .monospaced))
                                .kerning(0.69)
                                .textSelection(.enabled)
                                .foregroundStyle(Color.theme.inputText)
                        }
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
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
            .scrollContentBackground(.hidden)
            .listSectionSpacing(32)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle(subViewName)
            .task {
                
                if let savedCity = appState.selectedCity {
                    controller.selectedCity = savedCity
                }
            }
            .sheet(isPresented: $isPresentingPaywall) {
                PaywallView()
            }
            .presentCustomerCenter(isPresented: $isPresentingCustomerCenter)
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
                router.activeTab = 1
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
        .environment(SubscriptionManager.shared)
}
