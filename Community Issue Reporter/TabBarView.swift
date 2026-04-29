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
    @State private var selectedTab: Int = 1
    @State private var presentSheetOnDeepLink: Bool = false
    @AppStorage("openReportFromShortcut") private var openReportFromShortcut = false
    @State private var showShortcutReport: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Issues", systemImage: "map", value: 1) {
                ReportsView()
            }
            
            Tab("Sign petitions", systemImage: "signature", value: 2) {
               SignRequestsView()
            }
            
            Tab("Insights", systemImage: "sparkles", value: 3) {
                InsightsView()
            }
            
            Tab("Add", systemImage: "plus", value: 4, role: .search) {
                CreateReportView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        
        .onOpenURL { url in
            if url.host == "reports" {
                selectedTab = 1
                presentSheetOnDeepLink.toggle()
            }
        }
        .onAppear {
            if openReportFromShortcut {
                openReportFromShortcut = false
                showShortcutReport = true
            }
        }
        .onChange(of: openReportFromShortcut) { _, newValue in
            if newValue {
                openReportFromShortcut = false
                showShortcutReport = true
            }
        }
        .sheet(isPresented: $presentSheetOnDeepLink) {
            VStack {
                
                Text("Hello from sheet")
            }
        }
        .sheet(isPresented: $showShortcutReport) {
            ReportView(model: model, onCompletion: { _, _ in
                
            }, showCancelButton: true)
            .onAppear {
                model.setMatterToSolve(mattersToResolve.first!)
//                model.configure(with: settings)
            }
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
        
    }
}


#Preview {
    TabBarView()
}
