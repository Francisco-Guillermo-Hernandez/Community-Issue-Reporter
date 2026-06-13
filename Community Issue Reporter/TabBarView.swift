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
    
    @StateObject private var reportHandler = ReportDetailsHandler()
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab(String(localized: "Issues"), systemImage: "map", value: 1) {
                ReportsView()
                    .environmentObject(reportHandler)
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
        .tabBarMinimizeBehavior(.onScrollDown)
        .onOpenURL { url in
            
            guard let data = deepLinkHandler(url) else { return }
            
            if data.type == .report {
                selectedTab = 1
                
                retrieveAndPresentReportDetails(of: "f0a38d15-2546-4f13-b622-437299ae687a")
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
        .sheet(isPresented: $showShortcutReport) {
            ReportView(model: model, onCompletion: { _, _ in
                
            }, showCancelButton: true)
            .onAppear {
                model.setMatterToSolve(mattersToResolve.first!)
            }
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
        
    }
    
    ///
    private func retrieveAndPresentReportDetails(of reportId: String) {
        Task {
            ///
            reportHandler.isLoading = true
            await MapExplorerRepository.shared.report(
                 reportId,
                 countryCode: .SV,
                 cityId: "",
                 completion: { result in
                     
                     ///
                     reportHandler.isLoading = false
                     
                     switch result {
                     case .success(let report):
                         
                         print(report)
                         reportHandler.showDetails(of: report)
                         case .failure(let error):
                         print(error)
                         
                     }
                 }
             )
        }
    }
    
    ///
    private func retrieveAndPresentPetitionDetails(of petitionId: String) {
        Task {}
    }
}


#Preview {
    TabBarView()
        .environmentObject(AuthViewModel())
}
