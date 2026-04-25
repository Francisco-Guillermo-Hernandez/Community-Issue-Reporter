//
//  View+Modifier.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/4/26.
//

import SwiftUI

// MARK: - view modifier to personalize the cells of a List {}
struct CellViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.theme.foreground)
            .padding()
            .background(Color.theme.accent)
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                    .stroke(Color.theme.border, lineWidth: 1)
            )
            .cornerRadius(.themeRadius * 2)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 4,
                    leading: 16,
                    bottom: 4,
                    trailing: 16
                )
            )
    }
}

extension View {
    func cellStyle() -> some View {
        self.modifier(CellViewModifier())
    }
}

// MARK: - end
