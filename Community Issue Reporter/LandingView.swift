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
    @Binding var isGuest: Bool
    @State private var userOAuthState: UserOAuthResultState = .unowned
    @EnvironmentObject var appState: AuthViewModel
    @State private var path = [LandingNavigation]()
    @State private var selectedCity: FriendlyCityDistribution = .init(
        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
        firstLevel: "El Salvador",
        secondLevel: "San Salvador",
        thirdLevel: "San Salvador",
        ZipCode: "1101",
        legalGroupName: "Distrito de San Salvador",
        coordinates: .init(lat: 13.701270, lng: -89.224432),
        isCapitalCity: 1,
        isDepartmentalCapital: 1
    )
    var countryCode: CountryCode = .SV
    var body: some View {
        NavigationStack(path: $path) {

            
            LoginView() { session, type in
                handleLogin(for: session, with: type)
            }
            .navigationDestination(for: LandingNavigation.self) { destination in
                switch destination {
                case .selectCity:
                    CitySelectionView(
                        countryCode: countryCode,
                        selectedCity: $selectedCity,
                        nextStep: {
                            appState.selectedCity = selectedCity
                            path.append(.personalizeProfile)
                        }
                    )

                case .personalizeProfile:
                    UserPersonalizationView(nextStep: {
                        path.append(.essentialInfo)
                    })

                case .essentialInfo:
                    EssentialInformationView(finalStep: {
                        self.appState.isLoggedIn.toggle()
                    })

                }
            }
        }
        .onAppear {
            if let savedCity = appState.selectedCity {
                self.selectedCity = savedCity
            }
        }
    }
    
    private func handleLogin(for session: String, with type: LoginType) {
        if !session.isEmpty {
            if type == .guest {
                saveIntoKeychain(session)
                self.isGuest.toggle()
            } else {
                Task {
                    await UserRepository.shared.login(session,
                        onSuccess: { state, sessionId, data in
                        
                            self.userOAuthState = state
                           
                            if state == .firstLogin {
                                self.appState.landingViewMode.toggle()
                                path.append(.selectCity)
                            } else {
                                
                                
                                if data.landingPageCompleted {
                                    /// Set preferences 
                                    UserRepository.shared.setSettingsFromAuthenticatedUser(with: data)
                                    self.appState.isLoggedIn.toggle()
                                } else {
                                    
                                    /// Uncompleted landing process
                                    path.append(.selectCity)
                                    self.appState.landingViewMode.toggle()
                                }
                                
                            }
                        
                            self.saveIntoKeychain(sessionId)
                            
                        },
                        onError: { error in
                            print(error)
                        /// TODO: show errors
                        }
                    )
                }
            }
        } else {
            /// TODO: show error
        }
    }
    
    private func saveIntoKeychain(_ sessionId: String) {
        _ = KeychainService.save(key: .mutation, value: sessionId)
    }
}

#Preview {
    @Previewable
    @State var isGuest: Bool = false
    LandingView(isGuest: $isGuest)
        .environmentObject(AuthViewModel())
}
