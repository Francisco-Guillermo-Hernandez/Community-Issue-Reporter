//
//  CustomButton.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI

// MARK: - Define enum
enum ThemedButtonType {
    case primary
    case secondary
    case outline
}

enum ThemedButtonStyle {
    case prominent
    case normal
}

// MARK: -Custom button
struct ThemedButton: View {
    var message: String = ""
    var action: () -> Void = { }
    var type: ThemedButtonType = .secondary
    var style: ThemedButtonStyle = .prominent
    var body: some View {
        Button(action: action) {
            HStack {
                Text(message)
            }
            .padding(.themeSpacing * 3)
            .frame(maxWidth: .infinity, maxHeight: 48)
        }
        .buttonSizing(.flexible)
        .modifier(ButtonStyleMapper(type: type, style: style))
    }
}

// MARK: - util to use different styles
struct ButtonStyleMapper: ViewModifier {
    let type: ThemedButtonType
    let style: ThemedButtonStyle
    
    func body(content: Content) -> some View {
        switch type {
        case .primary:
            content.buttonStyle(ThemedPrimaryButtonStyle())
        case .secondary:
            content.buttonStyle(ThemedSecondaryButtonStyle())
        case .outline:
            content.buttonStyle(ThemedButtonOutlineStyle(style: style))
        }
    }
}

// MARK: - Button styles
struct ThemedPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(Color.init(hex: "1a181b"))
            .background(Color.theme.primary)
            .contentShape(Capsule())
            .clipShape(Capsule())
        
//            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
//            .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
        
            .font(Font.body.bold())
            .overlay {
                Capsule()
                    .stroke(Color.theme.primary.mix(with: .white, by: 0.3), lineWidth: 1)
            }
//            .overlay {
//                RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
//                    .stroke(Color.theme.primary.mix(with: .white, by: 0.3), lineWidth: 1)
//            }
            .glassEffect(in: Capsule())
        //.glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
    }
}

struct ThemedSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(Color.init(hex: "1a181b"))
            .background(Color.theme.secondary)
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .font(Font.body.bold())
            .overlay {
                RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                    .stroke(Color.theme.secondary.mix(with: .white, by: 0.3), lineWidth: 1)
            }
            .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
    }
}

struct ThemedButtonOutlineStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.isEnabled) var isEnabled
    let style: ThemedButtonStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(style == .normal ? .system(size: 14, weight: .medium) : Font.body.bold()) // style == .prominent ? Font.body.bold() : Font.body
            //.font(.system(size: 14, weight: .medium)) // text-sm font-medium
//            .frame(height: 36) // h-9
//            .padding(.horizontal, 12) // px-3
           
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundStyle(foregroundColor(isPressed: configuration.isPressed))
            .contentShape(Capsule())
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: 1)
            )
            .opacity(isEnabled ? 1.0 : 0.3) // disabled:opacity-50
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.2), value: isEnabled)
            .glassEffect(in: Capsule())
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            // dark:bg-input/30 dark:hover:bg-input/50
            return Color.theme.inputBackground.mix(with: .white, by: 0.67).opacity(isPressed ? 0.2 : 0.1)
        } else {
            // bg-background hover:bg-accent
//            return isPressed ? Color.theme.accent : Color.theme.background
            return isPressed ? Color.theme.accent : Color.white
        }
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.theme.foreground
        } else {
            // hover:text-accent-foreground
            return isPressed ? Color.theme.foreground : Color.theme.foreground
        }
    }
    
    private var borderColor: Color {
        if colorScheme == .dark {
            // dark:border-input
            return Color.theme.inputBorder
        } else {
            // border
            return Color.theme.border
        }
    }
}



struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .underline()
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: .themeSpacing * 4) {
        Spacer()
        ThemedButton(message: "Get Started", action: {}, type: .primary)
        
        ThemedButton(message: "Get Started", action: {}, type: .secondary)
        
        ThemedButton(message: "Get Started", action: {}, type: .outline)
        
        ThemedButton(message: "Get Started", action: {}, type: .outline, style: .normal)
        
        ThemedButton(message: "Get Started", action: {}, type: .outline).disabled(true)
        Spacer()
    }
    .padding()
//    .background(Color.theme.background.mix(with: Color.black, by: 0.01999))
//    .background(Color.init(hex: "#f0eee9"))
//    .background(Color.init(hex: "#FBF8F6")) <--
//    .background(Color.init(hex: "#F5F4E9"))
    .background(Color.theme.background)
//    .background(Color.init(hex: "F3F4F4"))
    
//    .background(Color.theme.background.mix(with: Color.black, by: 0.49))
    .frame(height: .infinity)
}
