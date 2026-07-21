//
//  ContentView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SettingsStore.self) var settings
    @State private var model = ReportDataModel.shared
    @State private var presentSheetOnDeepLink: Bool = false
    @AppStorage("openReportFromShortcut") private var openReportFromShortcut = false
    @State private var showShortcutReport: Bool = false
    @State private var router = DeepLinkRouter.shared
    
    var body: some View {
        TabView(selection: $router.activeTab) {
            
            Tab(String(localized: "Issues"), systemImage: "map", value: 1) {
                MapExplorerView()
            }
            .accessibilityIdentifier("MapExplorerTab")
            
            Tab(String(localized: "Sign petitions"), systemImage: "signature", value: 2) {
               SignRequestsView()
            }
            .accessibilityIdentifier("SignRequestsTab")
            
            Tab(String(localized: "Insights"), systemImage: "sparkles", value: 3) {
                InsightsView()
            }
            .accessibilityIdentifier("ShowInsightsTab")
            
            Tab(String(localized: "Add"), systemImage: "plus", value: 4, role: .search) {
                CreateReportView()
            }
            .accessibilityIdentifier("CreateReportTab")
        }
        .alert("Status Update", isPresented: $router.presentAlert) {
            Button("OK", role: .cancel) {
                router.presentAlert.toggle()
            }
        } message: {
            Text(router.message)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .task {
            router.isReadyToRoute = true
            router.processPendingDeepLink()
            
            if openReportFromShortcut {
                openReportFromShortcut = false
                showShortcutReport = true
            }
        }
        .onDisappear {
            router.isReadyToRoute = false
        }
        .onChange(of: openReportFromShortcut) { _, newValue in
            if newValue {
                openReportFromShortcut = false
                showShortcutReport = true
            }
        }
        .fullScreenCover(isPresented: $showShortcutReport) {
           
            ReportWizardContainer(model: model, onCompletion: { incomingMessage, alertType in
                router.message = incomingMessage
                router.presentAlert = true
            }, showCancelButton: true)
            .task {
                model.setMatterToSolve(mattersToResolve.first!)
            }
        }
        .sensoryFeedback(.selection, trigger: router.activeTab)
    }
}


#Preview {
    TabBarView()
        .environmentObject(AuthViewModel())
        .environment(DeepLinkRouter())
        .environment(SettingsStore())
}
