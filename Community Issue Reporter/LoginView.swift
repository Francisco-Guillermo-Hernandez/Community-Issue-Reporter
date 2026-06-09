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
    @Environment(\.colorScheme) private var colorScheme
    @State private var userOAuthState: UserOAuthResultState = .unowned
    @State private var enableBorderBeam: Bool = false
    @State private var disableLoginButtons: Bool = false
    
    let onTokenReceived: (String, LoginType) -> Void
    var body: some View {

        ZStack(alignment: .bottom) {
            
            Image("Login_background")
                .resizable()
                .backgroundExtensionEffect()
            
            VStack(spacing: .themeSpacing * 5) {
                
                VStack(alignment: .leading) {
                    Text("Repórtamelo")
                        .font(.custom("Lora", size: 24, relativeTo: .title))
                        .padding(.top, 16)
                        .kerning(0.1)
                    
                    Text("Report your problems and improve your community")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .kerning(-0.1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                GooglePillButton(action: loginWithGoogle)
                    .padding(.top, 8)
                    .disabled(disableLoginButtons)
                
                ThemedButton(
                    message: String(localized: "Login as a Guest"),
                    action: loginAsGuest,
                    type: .outline,
                    style: .normal
                )
                .frame(maxWidth: .infinity, maxHeight: 40)
                .disabled(disableLoginButtons)
                .padding(.bottom, 20)
                
                
                ///
                LinksView()
                

            }
            .padding(.horizontal, .themeSpacing * 8)
            .padding(.top, .themeSpacing * 4)
            .padding(.bottom, .themeSpacing * 8)
            .frame(maxWidth: .infinity)
            .borderBeam(
                border: Color.theme.primary,
                beam: [],
                beamBlur: 16,
                cornerRadius: 52,
                isEnabled: enableBorderBeam
            )
            .background(
                RoundedRectangle(cornerRadius: 52, style: .continuous)
                    .fill(Color.theme.cardBackground)
                    .glassEffect(in:  RoundedRectangle(cornerRadius: 52, style: .continuous))
            )
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            
            
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    func performLogin() {
        disableLoginButtons.toggle()
        enableBorderBeam.toggle()
    }
    
    func loginAsGuest() {
        Task {
            performLogin()
            await UserRepository.shared.loginAsGuest(
                onSuccess: { state, sessionId in
                    self.userOAuthState = state
                    onTokenReceived(sessionId, .guest)
                }, onError: { error in
                    print(error)
                    performLogin()
                }
            )
        }
    }
    
    func loginWithGoogle() {
        // Find the current window scene.
        performLogin()
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
                performLogin()
                // Inspect error
                print("Error signing in: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
//            performLogin()
            onTokenReceived(result.user.idToken?.tokenString ?? "", .user)
        }
    }

}

#Preview {
    LoginView() { _, _ in
        
    }
}
