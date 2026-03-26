//
//  Community_Issue_ReporterApp.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

@main
struct Community_Issue_ReporterApp: App {
    
    @State private var store = Store()
    
    init() {
        copyDatabaseIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.mySettings, store)
                .onOpenURL { url in
                    deepLinkHandler(url)
                }
        }
    }
}
