//
//  GooglePillButton.swift
//  Hello Google Auth
//
//  Created by Francisco Hernandez on 5/4/26.
//

import SwiftUI

struct GooglePillButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Group {
                HStack {
                    Image("Google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Sign in with Google")
                        .font(.custom("Roboto-Bold", size: 14))
                        .foregroundColor(Color("Google_font_color"))
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
        }
        .buttonSizing(.flexible)
        .buttonStyle(GooglePillButtonStyle())
        
    }
}

struct GooglePillButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .background(configuration.isPressed ? Color("Google_tapped_color").opacity(0.08) : Color("Google_background_color").mix(with: .white, by: 0.1))
//            .background(configuration.isPressed ? Color("Google_tapped_color").mix(with: .white, by: 0.9) : Color("Google_background_color"))
            .contentShape(Capsule())
            .clipShape(Capsule())
//            .overlay {
//                Capsule()
//                    .stroke(Color("Google_stroke_color"), lineWidth: 1)
//                
//            }
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: 1)
            )
            .opacity(isEnabled ? 1.0 : 0.3)
            .glassEffect(in: Capsule())
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
    NavigationStack {
        VStack(spacing: 16) {
            GooglePillButton(action: {
                
            })
            .disabled(true)
            
            GooglePillButton(action: {
                
            })
            .disabled(false)
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.theme.cardBackground)
      
    }
}
