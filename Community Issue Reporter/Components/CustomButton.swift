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
    var action: () -> Void
    var type: ThemedButtonType = .secondary
    var style: ThemedButtonStyle = .prominent
    var icon: String?
    var body: some View {
        Button(action: action) {
            HStack {
                if icon != nil {
                    Image(systemName: icon!)
                }
                
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

struct GlassBounceModifier: ViewModifier {
    var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.interpolatingSpring(stiffness: 256, damping: 40), value: isPressed)
    }
}

// MARK: - Button styles
struct ThemedPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .background(backgroundColor(isPressed: configuration.isPressed))
             .foregroundStyle(foregroundColor(isPressed: configuration.isPressed))
            .contentShape(Capsule())
            .clipShape(Capsule())
            .font(Font.body.bold())
            .overlay {
                Capsule()
                    .stroke(borderColor, lineWidth: isEnabled ? 1 : 0)
            }
            .opacity(isEnabled ? 1.0 : 0.51) // disabled:opacity-50
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.2), value: isEnabled)
            .glassEffect(.regular, in: Capsule())
            .modifier(GlassBounceModifier(isPressed: configuration.isPressed))
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return isPressed ? Color.theme.primary.opacity(0.86) : Color.theme.primary
        } else {
            return isPressed ? Color.theme.primary.opacity(0.75) : Color.theme.primary
        }
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return isPressed ? Color(hex: "#fed4a0") : Color.white  //Color.theme.cardBackground
        } else {
            return isPressed ? Color.init(hex: "#f2ebdd") : Color.white
        }
    }
    
    private var borderColor: Color {
        if colorScheme == .dark {
            return Color.theme.primary.mix(with: .white, by: 0.1)
        } else {
            return Color.theme.primary.mix(with: .white, by: 0.4)
        }
    }
}

struct ThemedSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(Color.white)
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
            .font(style == .normal ? .system(size: 14, weight: .regular) : Font.body.bold())
           
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
            .glassEffect(.regular, in: Capsule())
            .modifier(GlassBounceModifier(isPressed: configuration.isPressed))
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.theme.inputBackground.mix(with: .white, by: 0.67).opacity(isPressed ? 0.2 : 0.1)
        } else {
            return isPressed ? Color.theme.accent : Color.white
        }
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        if colorScheme == .dark {
            return Color.theme.foreground
        } else {
            // hover:text-accent-foreground
            return isPressed ? Color.theme.foreground.mix(with: .black, by: 0.67) : Color.theme.foreground
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
        
        ThemedButton(message: "Next Step", action: {}, type: .primary).disabled(true)
        Spacer()
        ThemedButton(message: "Get Started", action: {}, type: .primary)
        
        ThemedButton(message: "Get Started", action: {}, type: .secondary)
        
        ThemedButton(message: "Get Started", action: {}, type: .outline)
        
        ThemedButton(message: "Take a photo", action: {}, type: .outline, style: .normal, icon: "camera")
        
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
