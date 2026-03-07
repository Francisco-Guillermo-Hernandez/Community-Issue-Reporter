//
//  ContentView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI


struct TabBarView: View {
    
    @State private var searchText: String = ""
    @State private var selectedTab: Int = 1
    @State private var oldSelectedTab: Int = 1
    @State private var isPresented: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Reports", systemImage: "map", value: 1) {
                ReportsView()
            }
            
            Tab("Sign petitions", systemImage: "list.bullet.rectangle", value: 2) {
               SignRequestsView()
            }
            
            Tab("Add", systemImage: "plus", value: 3, role: .search) {}
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: selectedTab) { _, newValue in
            if newValue == 3 {
                isPresented = true
                selectedTab = oldSelectedTab
            } else {
                oldSelectedTab = newValue
            }
        }
        .sheet(isPresented: $isPresented) {
            ReportView()
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
        
    }
}


#Preview {
    TabBarView()
}
