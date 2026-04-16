//
//  CardModifier.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/4/26.
//

import SwiftUI

struct CardModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.clear)
                    
                    GeometryReader { geo in
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.mix(with: .black, by: 0.4).opacity(0.85),
                                color.opacity(0)
                            ]),
                            center: .bottomLeading,
                            startRadius: 0,
                            endRadius: geo.size.width * 0.8
                        )
                        
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
//            .shadow(color: Color.black.opacity(0.1), radius: 30, x: 0, y: 0)
    }
}

extension View {
    func cardStyle(color: Color) -> some View {
        self.modifier(CardModifier(color: color))
    }
}
