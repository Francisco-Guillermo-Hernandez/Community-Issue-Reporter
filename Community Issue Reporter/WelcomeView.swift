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
    
    @EnvironmentObject var appState: AuthViewModel
    
    var body: some View {
        ZStack {
            
            if controller.isLoggedIn {
                TabBarView()
            } else if controller.isGuest {
                if appState.selectedCity != nil {
                    TabBarView()
                } else {
                    NavigationStack {
                        CitySelectionView(
                            countryCode: controller.countryCode,
                            selectedCity: $controller.selectedCity,
                            nextStep: {
                                
                                _ = KeychainService.save(key: .userType, value: UserType.guest.description)
                                
                                appState.selectedCity = controller.selectedCity
                               
                                appState.setCameraPosition(
                                    to: controller.selectedCity.coordinates,
                                    latitudeDelta:  0.005738743213994368,
                                    longitudeDelta: 0.003718218254761041
                                )
                            }
                        )
                    }
                }
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
