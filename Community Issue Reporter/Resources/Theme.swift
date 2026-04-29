//
//  Theme.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/4/26.
//

import SwiftUI

struct AppTheme {
    // Helper to create dynamic colors
    private static func dynamicColor(
        light: Color,
        dark: Color
    ) -> Color {
        return Color(
            UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
            }
        )
    }
    
    // Colors
    static let background = dynamicColor(
        light: Color(
            red: 255/255,
            green: 255/255,
            blue: 255/255
        ),
        dark: Color(
            red: 26/255,
            green: 24/255,
            blue: 27/255
        )
    )
    
    static let cardBackground = dynamicColor(
        light: Color(
            red: 251/255,
            green: 251/255,
            blue: 251/255
        ),
        dark: Color(
            red: 18/255,
            green: 18/255,
            blue: 18/255
        )
    )
    
    static let cardForeground = dynamicColor(
        light: Color(
            red: 193/255,
            green: 193/255,
            blue: 193/255
        ),
        dark: Color(
            red: 56/255,
            green: 39/255,
            blue: 31/255
        )
    )
    
    static let foreground = dynamicColor(
        light: Color(
            red: 56/255,
            green: 39/255,
            blue: 31/255
        ),
        dark: Color(
            red: 193/255,
            green: 193/255,
            blue: 193/255
        )
    )
    
    static let primary = dynamicColor(
        light: Color(
            red: 246/255,
            green: 131/255,
            blue: 34/255
        ),
        dark: Color(
            red: 236/255,
            green: 148/255,
            blue: 88/255
        )
    )
    
    static let primaryForeground = dynamicColor(
        light: Color(
            red: 39/255,
            green: 22/255,
            blue: 17/255
        ),
        dark: Color(
            red: 26/255,
            green: 24/255,
            blue: 27/255
        )
    )
    
    static let secondary = dynamicColor(
        light: Color(
            red: 71/255,
            green: 181/255,
            blue: 188/255
        ),
        dark: Color(
            red: 97/255,
            green: 139/255,
            blue: 140/255
        )
    )
    
    static let muted = dynamicColor(
        light: Color(
            red: 242/255,
            green: 235/255,
            blue: 221/255
        ),
        dark: Color(
            red: 34/255,
            green: 34/255,
            blue: 34/255
        )
    )
    
    static let border = dynamicColor(
        light: Color(
            red: 222/255,
            green: 222/255,
            blue: 222/255
        ),
        dark: Color(
            red: 51/255,
            green: 51/255,
            blue: 51/255
        )
    )
    
    static let destructive = dynamicColor(
        light: Color(
            red: 244/255,
            green: 78/255,
            blue: 72/255
        ),
        dark: Color(
            red: 97/255,
            green: 139/255,
            blue: 140/255
        )
    )
    
    // Mark:
    static let accent = dynamicColor(
        light: Color(
            red: 245/255,
            green: 245/255,
            blue: 245/255
        ),
        dark: Color(
            red: 51/255,
            green: 51/255,
            blue: 51/255)
    )
}

let gridColumns: [GridItem] = [
    GridItem(.flexible(), spacing: .themeSpacing * 4),
]

let themeCellEdgeInsets  = EdgeInsets(
    top: .themeSpacing * 2,
    leading: .themeSpacing * 4,
    bottom: .themeSpacing * 2,
    trailing: .themeSpacing * 4
)

extension CGFloat {
    static let themeRadius: CGFloat = 12.0 // 0.75rem
    static let themeSpacing: CGFloat = 4.0 // 0.25rem
    static let themePadding: CGFloat = 16.0
    static let themeCardCornerRadius: CGFloat = 24.0
}

extension Color {
    static let theme = AppTheme.self
}
