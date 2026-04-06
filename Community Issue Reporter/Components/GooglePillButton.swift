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
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .background(configuration.isPressed ? Color("Google_tapped_color").opacity(0.08) : Color("Google_background_color"))
            .contentShape(Capsule())
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(Color("Google_stroke_color"), lineWidth: 1)
                
            }
    }
}


#Preview {
    GooglePillButton(action: {
        
    })
}
