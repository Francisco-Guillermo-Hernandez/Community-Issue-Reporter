//
//  CardInfoRow.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/4/26.
//

import SwiftUI

// MARK: - Model
struct CardInfoModelView: Encodable {
    let title: String
    let subtitle: String
    let stat: String
}

// MARK: - Card row
struct CardInfoRow: View {
    var data: CardInfoModelView
    var action: () -> Void
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: .themeSpacing * 3) {
            
            VStack(alignment: .leading) {
                Text(data.stat)
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .fontWidth(.compressed)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(data.title)
                    .font(.title3.bold())
                    .fontWidth(.condensed)
                
                HStack(spacing: 0) {
                    Text(data.subtitle)
                        .font(.footnote)
                        .opacity(0.6)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .regular, design: .default))
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .cardInfoStyle()
    }
}

// MARK: - Add extension
extension View {
    func cardInfoStyle() -> some View {
        self.modifier(CardInfoStyle())
    }
}

// MARK: - Theming
struct CardInfoStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 50) // Force the HStack to have a specific height so the infinity frames work
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .overlay(
                RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous)
                    .stroke(Color.theme.border, lineWidth: 1)
            )
            .foregroundColor(.theme.primary)
            .background(Color.init(hex: "121212"))
            .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
    }
}

struct StatCard: View {
    @Environment(\.colorScheme) var colorScheme
    var action: () -> Void
    let description: String
    let title: String
    let trend: String
    let timeframe: String
    var displayFooter: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            
            
            // Header
            VStack(alignment: .leading, spacing: 8) { // gap-2
                
               
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.foreground.opacity(0.6)) // text-muted-foreground
                Text(title)
                    .font(.system(size: 30, weight: .semibold)) // text-3xl font-semibold
                    .foregroundStyle(foregroundColor)
                    .fontWidth(.condensed)
                
                
            }
            .padding(.horizontal, 24) // px-6
            
            if displayFooter {
                // Footer
                VStack(alignment: .leading, spacing: 4) { // gap-1
                    Text(trend)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.theme.inputText)
                    
//                    Text(timeframe)
//                        .font(.subheadline)
//                        .foregroundStyle(Color.theme.foreground.opacity(0.6)) // text-muted-foreground
                }
                .padding(.horizontal, 24) // px-6
            }
        }
        .padding(.vertical, 24) // py-6
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color.theme.cardBackground, location: 0),
                    .init(color: Color.theme.primary.opacity(0.05), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(16) // rounded-xl
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.border, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1) // shadow-sm
    }
    
    var foregroundColor: Color {
        colorScheme == .light ?  Color.init(hex: "#38271F") : Color.init(hex: "#8a8a8a")
    }
}

#Preview {
    CardInfoRow(data: CardInfoModelView(title: "Title", subtitle: "Subtitle", stat: "100"), action: {})
}

#Preview("StatCard") {
    StatCard(
        action: {  } ,
        description: "I've Reported",
        title: "50",
        trend: "Incidents this month",
        timeframe: "for the last 6 months"
    )
    StatCard(
        action: {  },
        description: "I've Created Petitions",
        title: "5",
        trend: "Trending up this month",
        timeframe: "for the last 6 months"
    )
}
