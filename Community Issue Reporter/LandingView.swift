//
//  LandingView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/5/26.
//

import SwiftUI

enum LandingNavigation: Hashable {
    case selectCity
    case userProfile
    case essentialInfo

}

struct LandingView: View {
    @Binding var isGuest: Bool
    @State private var userOAuthState: UserOAuthResultState = .unowned
    @EnvironmentObject var appState: AuthViewModel
    @State private var path = [String]()
    @State private var selectedCity: FriendlyCityDistribution = .init(
        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
        firstLevel: "",
        secondLevel: "",
        thirdLevel: "",
        ZipCode: "",
        legalGroupName: "",
        coordinates: .init(lat: 0, lng: 0),
        isCapitalCity: 0,
        isDepartmentalCapital: 0
    )
    var countryCode: CountryCode = .SV
    var body: some View {
        NavigationStack(path: $path) {

            
            LoginView() { session, type in
                handleLogin(for: session, with: type)
            }
        }
        .navigationDestination(for: LandingNavigation.self) { destination in
            switch destination {
            case .selectCity:
                CitySelectionView(
                    countryCode: countryCode,
                    selectedCity: $selectedCity,
                    nextStep: {

                    }
                )

            case .userProfile:
                UserPersonalizationView(nextStep: {

                })

            case .essentialInfo:
                EssentialInformationView(finalStep: {

                })

            }

        }
    }
    
    private func handleLogin(for session: String, with type: LoginType) {
        if !session.isEmpty {
            if type == .visitor {
                Task {
                    await UserRepository.loginAsVisitor(
                        onSuccess: { state, sessionId in
                            self.userOAuthState = state
                            saveIntoKeychain(sessionId)
                            self.isGuest.toggle()
                        }, onError: { error in
                            print(error)
                        }
                    )
                }
            } else {
                Task {
                    await UserRepository.login(session,
                        onSuccess: { state, sessionId in
                        
                            self.userOAuthState = state
                           
                            if state == .firstLogin {
                                print("Welcome")
                            }
                        
                            self.saveIntoKeychain(sessionId)
                            self.appState.isLoggedIn.toggle()
                        },
                        onError: { error in
                            print(error)
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
}
