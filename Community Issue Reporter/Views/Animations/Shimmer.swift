//
//  Shimmer.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 12/6/26.
//

import SwiftUI

struct Shimmer: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoadingCardView()
}



//// 1. Create the Custom View Modifier
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    var isEnabled: Bool
    
    func body(content: Content) -> some View {
        if isEnabled {
            content
                .overlay(
                    GeometryReader { geo in
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.2), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .scaleEffect(2) // Scale up to ensure the diagonal sweep covers the entire view
                        .offset(x: (phase - 1) * geo.size.width)
                        .onAppear {
                            withAnimation(
                                .linear(duration: 3)
                                .repeatForever(autoreverses: false)
                            ) {
                                phase = 2
                            }
                        }
                    }
                )
                .mask(content) // Keeps the gradient bound inside the original view's boundaries
        } else {
            content
        }
    }
}



// Wrap the modifier in a convenient View extension
extension View {
    func shimmer(active: Bool = true) -> some View {
        modifier(ShimmerModifier(isEnabled: active))
    }
}



struct LoadingCardView: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            // Button to toggle loading simulation
            Button(isLoading ? "Loading..." : "Reload Data") {
                isLoading.toggle()
            }
            .padding(.bottom, 20)
            
            // The Card UI
            HStack(spacing: 16) {
                // Profile Image Placeholder
                Circle()
                    .fill(Color(.systemGray5))
                
                    .frame(width: 60, height: 60)
                    .shimmer(active: isLoading) // Sweeping light overlay
                
                // Text Fields Placeholders
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 140, height: 16)
                        .shimmer(active: isLoading)
                    
                    
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 200, height: 12)
                        .shimmer(active: isLoading)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8)
        }
        .padding()
    }
}
