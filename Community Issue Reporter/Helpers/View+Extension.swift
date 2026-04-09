//
//  View+Extension.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func optionalGlassEffect(_ colorScheme: ColorScheme, cornerRadius: CGFloat = 30) -> some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        
        if #available(iOS 26, *) {
            self
                .glassEffect(.clear.tint(backgroundColor.opacity(0.75)).interactive(), in: .rect(cornerRadius: cornerRadius, style: .continuous))
        } else {
            self
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                }
        }
    }
    
    @ViewBuilder
    func optionalGlassWithShape(_ colorScheme: ColorScheme, shape: some Shape) -> some View {
        let backgroundColor = colorScheme == .dark ? Color.black : Color.white
        
        if #available(iOS 26, *) {
            
            self
                .glassEffect(.clear.tint(backgroundColor.opacity(0.75)).interactive(), in: shape)
        } else {
            self
                .background {
                    shape
                        .fill(backgroundColor)
                }
        }
    }
}
