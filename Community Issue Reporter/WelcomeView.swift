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
    @State private var userOAuthState: UserOAuthResultState = .unowned
    
    var body: some View {
        ZStack {
            
            if appState.isCheckingStatus {
                ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if appState.isLoggedIn || isGuest {
                TabBarView()
            } else {
                LoginView() { token in
                    handleLogin(token: token)
                }
            }
        }
        .task {
            self.appState.checkStatus()
        }
    }
    
    private func handleLogin(token: String) {
        if !token.isEmpty {
            if token == "guest" {
                self.isGuest.toggle()
            } else {
                Task {
                    await UserRepository.login(token,
                        onSuccess: { state, resultToken in
                        
                            self.userOAuthState = state
                           
                            if state == .firstLogin {
                                print("Welcome")
                            }
                        
                            #if targetEnvironment(simulator)
                               /// todo
                            #else
                               _ = KeychainService.save(key: "token", value: resultToken)
                            #endif
                        
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
        
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
