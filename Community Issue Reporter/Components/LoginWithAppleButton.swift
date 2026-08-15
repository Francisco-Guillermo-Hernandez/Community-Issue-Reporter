//
//  LoginWithAppleButton.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 12/8/26.
//


import SwiftUI
import AuthenticationServices

enum AppleAuthError: Error {
    case noData(errorDescription: String)
    case noAuthorized(errorDescription: String)
    case noToken(errorDescription: String)
    
}

struct AuthPayload: Codable {
    let token: String
    let name: String?
    let email: String?
    
    init(token: String, name: String? = nil, email: String? = nil) {
        self.token = token
        self.name = name
        self.email = email
    }
    
    init(token: String) {
        self.token = token
        self.name = nil
        self.email = nil
    }
}


func checkAppleSignInState(forUserID userId: String) {
    let provider = ASAuthorizationAppleIDProvider()
    provider.getCredentialState(forUserID: userId) { state, error in
        DispatchQueue.main.async {
            switch state {
            case .authorized:
                // Keep user logged in
                break
            case .revoked, .notFound:
                // Perform local sign out / reset UI
                break
            @unknown default:
                break
            }
        }
    }
}


struct LoginWithAppleButton: View {
    @Environment(\.colorScheme) var colorScheme
    var action: (ASAuthorization?, AppleAuthError?) -> Void
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
              action(authResults, nil)
            case .failure(let error):
                action(nil, .noAuthorized(errorDescription: error.localizedDescription))
            }
        }
        .id(colorScheme) 
        .contentShape(Capsule())
        .clipShape(Capsule())
        .buttonBorderShape(.capsule)
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(height: 44)
        .overlay(
            Capsule()
                .stroke(borderColor, lineWidth: 1)
        )
        .glassEffect(in: .capsule)
    }
    
    
    private var borderColor: Color {
        if colorScheme == .dark {
            // dark:border-input
            return Color.theme.inputBorder
        } else {
            // border
            return Color.theme.border
        }
    }
    
}

#Preview {
    LoginWithAppleButton { (token, error) in
        if let token = token {
            print(token)
        }
        
        if let error = error {
            print(error)
        }
    }
}
