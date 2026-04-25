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
                Task {
                    await UserRepository.loginAsVisitor(
                        onSuccess: { state, token in
                            self.userOAuthState = state
                            saveTokens(u: token)
                            self.isGuest.toggle()
                        }, onError: { error in
                            print(error)
                        }
                    )
                }
            } else {
                Task {
                    await UserRepository.login(token,
                        onSuccess: { state, resultToken in
                        
                            self.userOAuthState = state
                           
                            if state == .firstLogin {
                                print("Welcome")
                            }
                        
                            self.saveTokens(u: resultToken)
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
    
    private func saveTokens(u: UserTokens) {
        _ = KeychainService.save(key: .query, value: u.queryActionsToken)
        _ = KeychainService.save(key: .mutation, value: u.mutationActionsToken)
    }
        
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
}
