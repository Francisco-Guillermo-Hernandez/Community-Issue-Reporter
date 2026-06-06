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
                .glassEffect(.clear.tint(backgroundColor.opacity(0.45)).interactive(), in: shape)
        } else {
            self
                .background {
                    shape
                        .fill(backgroundColor)
                }
        }
    }
}

// MARK: - Extension to transform a View to a UIImage
extension View {
    func asImage() -> UIImage? {
        let controller = UIHostingController(
            rootView: self.edgesIgnoringSafeArea(.all)
        )
        let view = controller.view

        let targetSize = CGSize(width: 200, height: 200)  // Fixed size for avatars
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(
                in: CGRect(origin: .zero, size: targetSize),
                afterScreenUpdates: true
            )
        }
    }
}
