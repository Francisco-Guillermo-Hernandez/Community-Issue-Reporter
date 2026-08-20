//
//  PetitionConfirmationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/7/26.
//

import SwiftUI

struct PetitionConfirmationView: View {
    @State private var isAnimating: Bool = true
    @Binding var url: String
    var goTo: () -> Void
    
    var body: some View {
        VStack(spacing: .themeSpacing * 6) {
            VStack(spacing: .themeSpacing * 4) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 56))
                    .symbolColorRenderingMode(.gradient)
                    .foregroundStyle(
                        Color.white,
                        Color.green,
                        Color.green
                    )
                    .symbolEffect(.drawOn, isActive: isAnimating)
                    .task {
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.375) {
                            isAnimating = false
                        }
                    }
                
                Text(String(localized: "Your petition has been submitted"))
                    .font(.title2)
                    .bold()
                
                Text(String(localized: "We will notify you in each step of the process to help you resolve problems in your community."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(String(localized: "Meanwhile, you can share your petition with your friends and neighbors to get them involved."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(String(localized: "You can spread the word to speed up the resolution of reports. \n and get more people involved."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                
            }
            
            VStack(spacing: .themeSpacing * 3) {
                ThemedButton(
                    message: String(localized: "See all of my petitions"),
                    action: goTo,
                    type: .outline,
                    style: .normal
                )
                
                ThemedButton(
                    message: String(localized: "Share Report"),
                    action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        shareFromClosure(item: buildShareURL(for: url)!)
                    },
                    type: .outline,
                    style: .normal,
                    icon: "square.and.arrow.up"
                )
                .accessibilityIdentifier("share-report")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 100)
        .padding(.vertical, 12)
    }
}

#Preview {
    PetitionConfirmationView(url: .constant("")) {
        print("Go to pressed")
    }
}
