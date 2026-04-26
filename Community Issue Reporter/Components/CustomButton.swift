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
    case generic
}

// MARK: -Custom button
struct ThemedButton: View {
    var message: String = ""
    var action: () -> Void = { }
    var type: ThemedButtonType = .secondary
    var body: some View {
        Button(action: action) {
            HStack {
                Text(message)
            }
            .padding(.themeSpacing * 3)
            .frame(maxWidth: .infinity, maxHeight: 48)
        }
        .buttonSizing(.flexible)
        .modifier(ButtonStyleMapper(type: type))
    }
}

// MARK: - util to use different styles
struct ButtonStyleMapper: ViewModifier {
    let type: ThemedButtonType
    
    func body(content: Content) -> some View {
        switch type {
        case .primary:
            content.buttonStyle(ThemedPrimaryButtonStyle())
        case .secondary:
            content.buttonStyle(ThemedSecondaryButtonStyle())
        case .generic:
            content.buttonStyle(ThemedButtonGenericStyle())
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
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .font(Font.body.bold())
            .overlay {
                RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                    .stroke(Color.theme.primary.mix(with: .white, by: 0.3), lineWidth: 1)
            }
            .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
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

struct ThemedButtonGenericStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(Color.theme.foreground)
            .background(Color.theme.muted)
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .font(Font.body.bold())
            .overlay {
                RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                    .stroke(Color.theme.muted.mix(with: .black, by: 0.3), lineWidth: 1)
            }
            .glassEffect(in: RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
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
    ThemedButton(message: "Get Started", action: {}, type: .primary)
}
