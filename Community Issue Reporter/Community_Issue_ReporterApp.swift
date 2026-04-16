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
    
    @StateObject private var authViewModel = AuthViewModel()
    @State private var store = Store()
    @AppStorage("selectedLanguage") private var languageCode = "es-419"
    
    init() {
        copyDatabaseIfNeeded()
        AppShortcuts.updateAppShortcutParameters()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(authViewModel)
                .environment(\.mySettings, store)
                .environment(\.locale, .init(identifier: languageCode))
                .onOpenURL { url in
                    deepLinkHandler(url)
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
