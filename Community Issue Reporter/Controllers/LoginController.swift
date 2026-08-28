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
import AuthenticationServices

typealias OnTokenReceived = (AuthPayload, LoginType) -> Void


@MainActor
@Observable
final class LoginController {
    
    static let shared = LoginController()
    private(set) var enableBorderBeam: Bool = false
    private(set) var disableLoginButtons: Bool = false
    private(set) var userOAuthState: UserOAuthResultState = .unowned
    var showErrorAlert: Bool = false
    private(set) var messageError: String = ""
    var lastAuthMethod: String? = KeychainService.loadToken(key: .authMethod)
    
    func performLoginActions() {
        disableLoginButtons.toggle()
        enableBorderBeam.toggle()
    }
    
    func loginAsGuest(onTokenReceived: @escaping OnTokenReceived) {
        Task {
            do {
                performLoginActions()
                let (state, sessionId) = try await UserRepository.shared.loginAsGuest()
                userOAuthState = state
                onTokenReceived(.init(token: sessionId), .guest)
                
            } catch CommonIntercommunicationErrors.unProcessable {
                self.show(error: String(localized: "Your petition cannot be processed, please try again."))
            } catch CommonIntercommunicationErrors.networkError(_) {
                self.show(error: String(localized: "It looks like that your network is experiencing some delays, please try again."))
            } catch CommonIntercommunicationErrors.serverError(_) {
                self.show(error: String(localized: "Server error, please try again."))
            } catch {
                self.show(error: String(localized: "An unexpected error has occurred, please try again."))
            }
            
            performLoginActions()
        }
    }
    
    func loginWithGoogle(onTokenReceived: @escaping OnTokenReceived) {
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
                
                onTokenReceived(.init(token: tokenString), .user(authMethod: .Google))
            } catch {
                performLoginActions()
            }
        }
    }
    
    func loginWithApple(_ authResults: ASAuthorization, onTokenReceived: @escaping OnTokenReceived) {
        
        Task {
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenData = appleIDCredential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
                performLoginActions()
                return
            }
            
            /// These are ONLY populated on the very first login.
            /// If they are nil, it means the user has logged in before.
            let email = appleIDCredential.email
            let firstName = appleIDCredential.fullName?.givenName
            let lastName = appleIDCredential.fullName?.familyName
            let fullName = [firstName, lastName].compactMap { $0 }.joined(separator: " ")
            
            let payload = AuthPayload(
                token: identityToken,
                name: fullName.isEmpty ? nil : fullName,
                email: email
            )
            performLoginActions()
            
            onTokenReceived(payload, .user(authMethod: .Apple))
        }
    }
    
    func show(error: String) {
        self.messageError = error
        self.showErrorAlert = true
    }
    
    func handle(error: Error?) {
        if let error = error {
            show(error: error.localizedDescription)
        }
    }
}
