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
            
            VStack(spacing: .themeSpacing * 4) {
                
                VStack(alignment: .leading) {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: .themeSpacing * 3) {
                    VStack(spacing: .themeSpacing) {
                        LoginWithAppleButton { (result, error) in
                            
                            if let result = result {
                                controller.loginWithApple(result, onTokenReceived: onTokenReceived)
                            }
                            
                            controller.handle(error: error)
                        }
                        .disabled(controller.disableLoginButtons)
                        
                        if controller.lastAuthMethod == AuthMethod.Apple.rawValue {
                            Text("Last login")
                                .foregroundStyle(.secondary)
                                .font(.caption2).bold()
                        }
                    }
                    
                    
                    VStack(spacing: .themeSpacing) {
                        GooglePillButton(action: {
                            controller.loginWithGoogle(onTokenReceived: onTokenReceived)
                        })
                        .disabled(controller.disableLoginButtons)
                        .accessibilityIdentifier("LoginWithGoogle")
                        .accessibilityLabel(String(localized: "Sign in with Google"))
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        
                        if controller.lastAuthMethod == AuthMethod.Google.rawValue {
                            Text("Last login")
                                .foregroundStyle(.secondary)
                                .font(.caption2).bold()
                        }
                    }
                    
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
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(String(localized: "Login as a Guest"))
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                
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
                    .fill(Color.theme.background)
                    .glassEffect(in:  RoundedRectangle(cornerRadius: 52, style: .continuous))
            )
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
        .alert(String(localized: "Error"), isPresented: $controller.showErrorAlert) {
            Button(role: .close) {
                
            } label: {
                Text("Ok")
            }
        } message: {
            Text(controller.messageError)
        }
    }
}

#Preview {
    LoginView() { _, _ in }
}
