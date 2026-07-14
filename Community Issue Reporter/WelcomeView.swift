//
//  WelcomeView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import SwiftUI

struct WelcomeView: View {
    @State private var controller = LandingController.shared
    @Environment(SettingsStore.self) var settings
    
    var body: some View {
        ZStack {
            
            if controller.isLoggedIn || controller.isGuest {
                TabBarView()
            } else {
                LandingView(controller: controller)
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
        .environment(SettingsStore())
}
