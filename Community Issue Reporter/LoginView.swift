//
//  LoginView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    let onTokenReceived: (String) -> Void
    var body: some View {
        VStack() {
            Spacer()
            GooglePillButton(action: loginWithGoogle)
                .padding(.bottom, 20)
            Button {
                onTokenReceived("guest")
            } label: {
                Text("Login as a guest")
            }
            .buttonStyle(.borderless)
            .buttonSizing(.flexible)
        }
        .padding()
    }
    
    func loginWithGoogle() {
        // Find the current window scene.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("There is no active window scene")
            return
        }
        
        // Get the root view controller from the window scene.
        guard
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?
                .rootViewController
        else {
            print("There is no key window or root view controller")
            return
        }
        
        // Start the sign-in process.
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            
            guard let result = signInResult else {
                // Inspect error
                print("Error signing in: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            onTokenReceived(result.user.idToken?.tokenString ?? "")
            
        }
    }
}

#Preview {
    LoginView() { token in
        print(token)
    }
}
