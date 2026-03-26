//
//  ContentView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI


struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText: String = ""
    @State private var selectedTab: Int = 1
    @State private var oldSelectedTab: Int = 1
    @State private var isPresented: Bool = false
    @State private var message: String = ""
    @State private var type: AlertType = .success
    @State private var show = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Issues", systemImage: "map", value: 1) {
                ReportsView()
            }
            
            Tab("Sign petitions", systemImage: "signature", value: 2) {
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
            ReportView(onCompletion: { incomingMessage, alertType in
                message = incomingMessage
                type = alertType
                show = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.show = false
                    self.isPresented = false
                }
            })
        }
        .overlay(alignment: .bottom) {
            if show {
                Group {
                    if #available(iOS 26, *) {
                        CustomAlert(message: message, type: type)
                            .transition(.asymmetric(insertion: .identity, removal: .opacity))
                            .optionalGlassEffect(colorScheme, cornerRadius: 16)
                    }
                }
                .offset(x: 0, y: -62)
            }
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
        
    }
}


#Preview {
    TabBarView()
}
