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
    @State private var controller = LoginController.shared
    
    let onTokenReceived: (AuthPayload, LoginType) -> Void
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Image("Login_background")
                .resizable()
                .backgroundExtensionEffect()
            
            VStack(spacing: .themeSpacing * 5) {
                
                VStack(alignment: .center) {
                    Text("Repórtamelo")
                        .fontWeight(.medium)
                        .font(.custom("Lora", size: 24, relativeTo: .title))
                        .padding(.top, 16)
                        .kerning(0.6)
                    
                    Text("Report your problems and improve your community")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .kerning(-0.1)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(spacing: .themeRadius * 1) {
                    LoginWithAppleButton { (result, error) in
                        
                        if let result = result {
                            controller.loginWithApple(result, onTokenReceived: onTokenReceived)
                        }
                        
                        if let error = error {
                            print(error)
                        }
                    }
                    .disabled(controller.disableLoginButtons)
                    
                    GooglePillButton(action: {
                        controller.loginWithGoogle(onTokenReceived: onTokenReceived)
                    })
                    .disabled(controller.disableLoginButtons)
                    .accessibilityIdentifier("LoginWithGoogle")
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    
                    ThemedButton(
                        message: String(localized: "Login as a Guest"),
                        action: {
                            controller.loginAsGuest(onTokenReceived: onTokenReceived)
                        },
                        type: .outline,
                        style: .normal
                    )
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .disabled(controller.disableLoginButtons)
                    .accessibilityIdentifier("LoginAsGuest")
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                /// Terms and conditions
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
                isEnabled: controller.enableBorderBeam
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
}

#Preview {
    LoginView() { _, _ in }
}
