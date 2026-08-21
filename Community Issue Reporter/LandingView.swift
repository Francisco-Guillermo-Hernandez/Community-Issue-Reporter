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

            LoginView { payload, type in
                controller.handleLogin(for: payload, with: type, appState)
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
                            DeepLinkRouter.shared.activeTab = 1
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
        .alert(String(localized: "Account Deleted"), isPresented: $controller.accountDeleted) {
            Button(String(localized: "OK"), role: .cancel) { }
        } message: {
            Text(String(localized: "Your account was deleted, but you can register again whenever you want. "))
        }
        .alert(controller.alertTitle, isPresented: $controller.presentAlert) {
            Button(String(localized: "OK"), role: .cancel) { }
        } message: {
            Text(controller.message)
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
