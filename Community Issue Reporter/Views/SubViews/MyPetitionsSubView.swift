//
//  MyPetitionsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct PetitionCellView: View {
    var petition: Petition
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(petition.title)
                        .font(.title2)
                        .fontWidth(.condensed)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(petition.description)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, .themeSpacing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MyPetitionsSubView: View {
    @State private var refreshID = UUID()
    @State private var petitions: [Petition] = []
    @State private var page: Int = 1
    @State private var model: PetitionDataModel = PetitionDataModel.shared
    
    var subViewName: String
    var body: some View {
        List {
            ForEach(petitions, id: \.id) { petition in
                ZStack {
                    NavigationLink(destination: self.petition(petition)) {
                        EmptyView().frame(width: 0, height: 0)
                    }
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    
                    PetitionCellView(petition: petition)
                        .cellStyle()
                }
            }
        }
        .task(id: refreshID) {
            await fetchPetitions()
        }
        .onAppear {
            refreshID = UUID()
        }
        .listStyle(.plain)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .navigationTitle(subViewName)
    }
    
    private func fetchPetitions() async {
        await PetitionRepository.share.list(q: PaginatedRequestQueryParams(page: 1, limit: 16), locator: Locator(countryCode: "", country: "", region: "", city: "", address: ""), onComplete: { result in
            
            guard let documents = result.documents else { return }
            petitions.append(contentsOf: documents)
            
            
        }, onError: { error in
            print(error)
        })
    }
    
    @ViewBuilder
    private func petition(_ petition: Petition) -> some View {
        CreateRequestPetitionView(model: model)
            .onAppear {
                model.prepareForModification(petition)
            }
    }
}

#Preview {
    MyPetitionsSubView(subViewName: "My Petitions")
}


//import SwiftUI


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

//extension View {
//    /// Applies a complex layered gradient designed for top-to-bottom falloff,
//    /// integrating an adaptive solid background (#242020 dark, #ffffff light)
//    /// and a vibrant orange glow (#f68322).
//    func themeGradientBackground() -> some View {
//        self.modifier(ThemeGradientModifier())
//    }
//}


// MARK: - Preview

//#Preview {
//    NavigationStack {
//        MyPetitionsSubView(subViewName: "My Petitions")
//    }
//}


import SwiftUI

struct ReportCardView: View {
    
    @Environment(\.colorScheme) var colorScheme

    var cardBackground = Color(hex: "#121212")
    var primaryAccent = Color(hex: "#ec9458").opacity(0.05)
    var foreground = Color(hex: "#c1c1c1")
    var mutedForeground = Color(hex: "#8a8a8a")
    var borderColor = Color(hex: "#333333")

//    init() {
//
//        if colorScheme == .dark {
//            self.cardBackground = Color(hex: "#121212")
//            self.primaryAccent = Color(hex: "#ec9458").opacity(0.05)
//            self.foreground = Color(hex: "#c1c1c1")
//            self.mutedForeground = Color(hex: "#8a8a8a")
//            self.borderColor = Color(hex: "#333333")
//        } else {
//            self.cardBackground = Color(hex: "#fbfbfb")
//            self.primaryAccent = Color(hex: "#f68322").opacity(0.05)
//            self.foreground = Color(hex: "#38271f")
//            self.mutedForeground = Color(hex: "#38271f")
//            self.borderColor = Color(hex: "#dedede")
//        }
//    }
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Reports created")
                    .font(.system(size: 14))
                    .foregroundColor(mutedForeground)
                
                Text("50")
                    .font(.system(size: 32, weight: .semibold, design: .default))
                    .foregroundColor(foreground)
                    .monospacedDigit()
            }
            
//             Footer Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Trending up this month")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(foreground)
                
                Text("for the last 6 months")
                    .font(.system(size: 14))
                    .foregroundColor(mutedForeground)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme.primary.opacity(0.05), Color.theme.cardBackground]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
//        .padding()
    }
}



//#Preview("other") {
//    ZStack {
//        Color(hex: "#1a181b").ignoresSafeArea()
//        ReportCardView()
//    }
//}
