//
//  ContentView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI


struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.mySettings) var settings
    @State private var model = ReportDataModel.shared
    @State private var presentSheetOnDeepLink: Bool = false
    @AppStorage("openReportFromShortcut") private var openReportFromShortcut = false
    @State private var showShortcutReport: Bool = false
    @EnvironmentObject var router: DeepLinkRouter
    
    var body: some View {
        TabView(selection: $router.activeTab) {
            
            Tab(String(localized: "Issues"), systemImage: "map", value: 1) {
                ReportsView()
                    .environmentObject(router)
            }
            
            Tab(String(localized: "Sign petitions"), systemImage: "signature", value: 2) {
               SignRequestsView()
            }
            
            Tab(String(localized: "Insights"), systemImage: "sparkles", value: 3) {
                InsightsView()
            }
            
            Tab(String(localized: "Add"), systemImage: "plus", value: 4, role: .search) {
                CreateReportView()
            }
        }
        .alert("Status Update", isPresented: $router.presentAlert) {
            Button("OK", role: .cancel) { }
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
        .environmentObject(DeepLinkRouter())
        .environmentObject(LandingController())
}
