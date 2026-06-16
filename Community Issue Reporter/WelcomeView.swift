//
//  WelcomeView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var controller: LandingController = .init()
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        ZStack {
            
            if controller.isLoggedIn || controller.isGuest {
                TabBarView()
                    .environmentObject(controller)
            } else {
                LandingView()
                    .environmentObject(controller)
            }
        }
        .task {
            self.controller.inject(self.settings)
            self.controller.checkStatus()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(LandingController())
}
