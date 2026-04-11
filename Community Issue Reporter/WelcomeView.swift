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
        .onAppear {
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
                        onSuccess: {
                           
                            #if targetEnvironment(simulator)
                               /// todo
                            #else
                               _ = KeychainService.save(key: "token", value: token)
                            #endif
                        
                            self.appState.checkStatus()
                        },
                        onError: { error in
                            print(error)
                        })
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
