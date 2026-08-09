//
//  LoginController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/8/26.
//

import Foundation
import Observation
import GoogleSignIn
import GoogleSignInSwift

@MainActor
@Observable
final class LoginController {
    
    static let shared = LoginController()
    
    private(set) var enableBorderBeam: Bool = false
    private(set) var disableLoginButtons: Bool = false
    private(set) var userOAuthState: UserOAuthResultState = .unowned
    
    func performLoginActions() {
        disableLoginButtons.toggle()
        enableBorderBeam.toggle()
    }
    
    func loginAsGuest(onTokenReceived: @escaping (String, LoginType) -> Void) {
        Task {
            do {
                performLoginActions()
                let (state, sessionId) = try await UserRepository.shared.loginAsGuest()
                userOAuthState = state
                onTokenReceived(sessionId, .guest)
                
            } catch {
                
            }
            
            performLoginActions()
        }
    }
    
    func loginWithGoogle(onTokenReceived: @escaping (String, LoginType) -> Void) {
        Task {
            /// Find the current window scene.
            performLoginActions()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                print("There is no active window scene")
                performLoginActions()
                return
            }
            
            /// Get the root view controller from the window scene.
            guard
                let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?
                    .rootViewController
            else {
                print("There is no key window or root view controller")
                performLoginActions()
                return
            }
            
            
            do {
                let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = signInResult.user
                guard let tokenString = user.idToken?.tokenString else {
                    performLoginActions()
                    return
                }
                onTokenReceived(tokenString, .user)
            } catch {
                performLoginActions()
            }
        }
    }
    
}
