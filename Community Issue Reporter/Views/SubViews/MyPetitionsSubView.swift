//
//  MyPetitionsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct MyPetitionsSubView: View {
    var subViewName: String
    var body: some View {
        NavigationStack {
            List {
                Text("Sample Petition 1").cellStyle()
                               Text("Sample Petition 2").cellStyle()
                               Text("Sample Petition 3").cellStyle()
                               Text("Sample Petition 4").cellStyle()
            }
            
            .listStyle(.plain)
//            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            
            .navigationTitle(subViewName)
            .toolbarTitleDisplayMode(.inlineLarge)
           
            .scrollContentBackground(.hidden)
            .themeGradientBackground()
            .tint(Color.theme.primary)
        }
        .foregroundColor(Color(hex: "ec9458"))
    }
}

#Preview {
    MyPetitionsSubView(subViewName: "My Petitions")
}


import SwiftUI


// MARK: - Theme Gradient Modifier

struct ThemeGradientModifier: ViewModifier {
    // 1. Detect the current user interface style (light/dark)
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            // Use ZStack to place the complex background BEHIND the view content
            .background(
                ZStack {
                    // LAYER 1: Adaptive Solid Background
                    // This color defines the bottom and edges of the view.
                    // Light Mode: #ffffff (White)
                    // Dark Mode:  #242020 (Very Dark Gray)
                    Color(hex: colorScheme == .dark ? "242020" : "ffffff")
                    
                    // LAYER 2: The complex orange glow (Radial Gradient combination)
                    // This replicates the overlapping circle effect seen in the screenshots.
                    orangeGlow
                }
                .ignoresSafeArea() // Ensure the gradient fills the status bar area
            )
    }
    
    // Abstracted view for the complex orange glow
    private var orangeGlow: some View {
        GeometryReader { geometry in
            // Calculate center based on screen geometry
//            let centerX = geometry.size.width / 2
            let totalHeight = geometry.size.height
            
            // Define the primary orange color: #f68322
            let orangeColor = Color(hex: "f68322")
            
            // Layer 2a: Diffuse Glow (Soft Falloff)
            // This gradient creates a large, subtle orange pool that fades
            // into transparency, allowing the solid background (Layer 1) to show through.
            RadialGradient(
                gradient: Gradient(stops: [
                    // Start strong at the center top
                    .init(color: orangeColor, location: 0.0),
                    // Begin gradual fade out
                    .init(color: orangeColor.opacity(0.8), location: 0.3),
                    // Full transparency before the halfway point
                    .init(color: .clear, location: 0.7)
                ]),
                center: UnitPoint(x: 0.5, y: -0.1), // Offset center slightly above the view
                startRadius: 0,
                endRadius: totalHeight * 0.9 // Very large diffuse radius
            )
            
            // Layer 2b: Core Glow (Vibrant Center)
            // This gradient is much smaller and defines the main "light source"
            // that makes the center-top look brighter, as requested in the SVG analysis.
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: orangeColor, location: 0.0),
                    .init(color: orangeColor.opacity(0.9), location: 0.2),
                    .init(color: .clear, location: 1.0)
                ]),
                center: UnitPoint(x: 0.5, y: 0.1), // Center aligns closely with center x
                startRadius: 0,
                endRadius: totalHeight * 0.5 // Smaller, more concentrated core
            )
        }
    }
}

// MARK: - View Extension for Easy Application

extension View {
    /// Applies a complex layered gradient designed for top-to-bottom falloff,
    /// integrating an adaptive solid background (#242020 dark, #ffffff light)
    /// and a vibrant orange glow (#f68322).
    func themeGradientBackground() -> some View {
        self.modifier(ThemeGradientModifier())
    }
}


// MARK: - Preview

#Preview {
    NavigationStack {
        MyPetitionsSubView(subViewName: "My Petitions")
    }
}
