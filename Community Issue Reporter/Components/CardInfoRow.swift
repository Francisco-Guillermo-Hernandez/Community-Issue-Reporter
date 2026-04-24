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
    var action: () -> Void = { }
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
            .foregroundColor(Color(hex: "1a181b"))
            .background(Color(hex: "ec9458"))
            .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
    }
}

#Preview {
    CardInfoRow(data: CardInfoModelView(title: "Title", subtitle: "Subtitle", stat: "100"))
}
