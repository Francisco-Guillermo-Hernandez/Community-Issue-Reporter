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
    
    // Inject
    @StateObject private var authViewModel = AuthViewModel()
    
    //
    @State private var store = SettingsStore.shared
    
    // Inject the AppDelegate lifecycle adaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Reference the manager state
    @StateObject private var notificationManager = AppDelegate.sharedNotificationManager
    
    init() {
        copyDatabaseIfNeeded()
        AppShortcuts.updateAppShortcutParameters()
        
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(authViewModel)
                .environment(\.mySettings, store)
                .environmentObject(notificationManager)
                .environment(\.locale, .init(identifier: store.selectedLanguageCode))
                .onOpenURL { url in
                    deepLinkHandler(url)
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
    
}
