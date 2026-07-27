//
//  PetitionConfirmationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/7/26.
//

import SwiftUI

struct PetitionConfirmationView: View {
    @State private var isAnimating: Bool = true
    
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
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.675) {
                            isAnimating = false
                        }
                    }
                
                Text(String(localized: "Your petition has been submitted"))
                    .font(.title2)
                    .bold()
                
                Text(String(localized: "."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(String(localized: "Meanwhile, you can copy petition code or share it with others."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                
            }
            
            VStack(spacing: .themeSpacing * 3) {
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 100)
        .padding(.vertical, 12)
    }
}

#Preview {
    PetitionConfirmationView()
}
