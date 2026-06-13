//
//  WelcomeView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AuthViewModel
    @State private var isGuest: Bool = false
    
    var body: some View {
        ZStack {
            
            if appState.isCheckingStatus {
                LoadingView()
            } else if appState.isLoggedIn || isGuest {
                TabBarView()
            } else {
                LandingView(isGuest: $isGuest)
            }
        }
        .task {
            self.appState.checkStatus()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
