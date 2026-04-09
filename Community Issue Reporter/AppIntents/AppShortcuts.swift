//
//  AppShortcuts.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/4/26.
//

import SwiftUI
import Foundation
import AppIntents

struct CreateReportAppIntent: AppIntent {
   
    static var title: LocalizedStringResource = "Shortcuts"
    static var description = IntentDescription("Create a shortcuts to report issues")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "openReportFromShortcut")
        return .result()
    }
}

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateReportAppIntent(),
            phrases: ["Create a report on \(.applicationName)", "Report an issue on\(.applicationName)"],
            shortTitle: "Create a report",
            systemImageName: "plus"
        )
    }
}
