//
//  LandingView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/5/26.
//

import SwiftUI

enum LandingNavigation: Hashable {
    case selectCity
    case personalizeProfile
    case essentialInfo
}

struct LandingView: View {
    @Bindable var controller: LandingController
    @EnvironmentObject var appState: AuthViewModel
    
    var body: some View {
        NavigationStack(path: $controller.path) {

            LoginView() { session, type in
                controller.handleLogin(for: session, with: type, appState)
            }
            .navigationDestination(for: LandingNavigation.self) { destination in
                switch destination {
                    /// Step to choose the city that user prefer to report issues/problems
                    case .selectCity:
                    CitySelectionView(
                        countryCode: controller.countryCode,
                        selectedCity: $controller.selectedCity,
                        nextStep: {
                            appState.selectedCity = controller.selectedCity
                           
                            appState.setCameraPosition(
                                to: controller.selectedCity.coordinates,
                                latitudeDelta:  0.005738743213994368,
                                longitudeDelta: 0.003718218254761041,
                            )
                            
                            controller.path.append(.personalizeProfile)
                        }
                    )
                    
                    ///
                    case .personalizeProfile:
                    UserPersonalizationView(
                        model: $controller.userPersonalizationDataModel,
                        nextStep: {
                            controller.path.append(.essentialInfo)
                        }
                    )

                    ///
                    case .essentialInfo:
                    EssentialInformationView(
                        notifications: $controller.notifications,
                        finalStep: {
                            _ = KeychainService.save(key: .sessionStateVerification, value: "session:state:valid")
                            controller.isLoggedIn.toggle()
                        }
                    )
                }
            }
        }
        .task {
            if let savedCity = appState.selectedCity {
                controller.selectedCity = savedCity
            }
        }
    }
    
}

#Preview {
    @Previewable
    @State var isGuest: Bool = false
    
    @State var controller = LandingController.shared
    LandingView(controller: controller)
        .environmentObject(AuthViewModel())
}
