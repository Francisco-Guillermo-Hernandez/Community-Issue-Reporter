//
//  Community_Issue_ReporterApp.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI
import GoogleSignIn
import AppIntents
import WidgetKit

@main
struct Community_Issue_ReporterApp: App {
    
    /// Inject auth view model to persist data related with Google auth
    @StateObject private var authViewModel = AuthViewModel()
    
    /// Inject settings store
    @StateObject private var settingsStore = SettingsStore()
    
    /// Inject network monitor
    @StateObject private var networkMonitor = NetworkMonitor()
    
    /// Inject the AppDelegate lifecycle adaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    /// Reference the manager state
    @StateObject private var notificationManager = AppDelegate.sharedNotificationManager
    
    /// Router
    @StateObject private var router = DeepLinkRouter()
    
    init() {
        copyDatabaseIfNeeded()
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" &&
           ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PLAYGROUNDS"] != "1" {
            AppShortcuts.updateAppShortcutParameters()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(router)
                .environmentObject(authViewModel)
                .environmentObject(settingsStore)
                .environmentObject(notificationManager)
                .environmentObject(networkMonitor)
                .environment(\.locale, .init(identifier: settingsStore.selectedLanguageCode))
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                    router.handleIncomingURL(url)
                }
        }
    }
}
