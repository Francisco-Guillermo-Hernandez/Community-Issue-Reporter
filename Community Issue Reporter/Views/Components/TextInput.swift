//
//  TextInput.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import SwiftUI

enum TextInputStatus: String, CaseIterable, Codable {
    case valid
    case invalid
    case error
    case untouched
    
    var color: Color {
        switch self {
        case .valid:
            return .green
        case .invalid:
            return .red
        case .error:
            return .red
        case .untouched:
            return .secondary
        }
    }
}

struct TailwindInputModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var isFocused: Bool
    var isInvalid: Bool
    var isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .frame(height: 36)
            .font(.system(size: 14)) // md:text-sm
            .background(
                colorScheme == .dark ? Color.theme.inputBackground.opacity(0.3) : Color.clear
            )
            .clipShape(Capsule())
            .contentShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isInvalid ? Color.theme.destructive : (isFocused ? Color.theme.inputRing : Color.theme.inputBorder),
                        lineWidth: 1
                    )
            )
            .background(
                Capsule()
                    .stroke(
                        isInvalid ? Color.theme.destructive.opacity(0.2) : (isFocused ? Color.theme.inputRing.opacity(0.5) : Color.clear),
                        lineWidth: 3
                    )
                    .padding(-1.5) // Half of line width to grow outwards
            )
            .opacity(isDisabled ? 0.5 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isFocused)
            .animation(.easeOut(duration: 0.2), value: isInvalid)
    }
}

extension View {
    func tailwindInputStyle(isFocused: Bool, isInvalid: Bool, isDisabled: Bool) -> some View {
        self.modifier(TailwindInputModifier(isFocused: isFocused, isInvalid: isInvalid, isDisabled: isDisabled))
    }
}


struct TextInput: View {
    var name: String = "placeholder"
    var label: String = "Email"
    var validators: [Validator] = []
    var regex: String = "[a-zA-Z0-9,\\u00C0-\\u00FF ]"
    var axis: Axis = .horizontal
    
    @State private var message: String = ""
    @State private var isValid: Bool = true
    @State private var status: TextInputStatus = .untouched
    @Binding var value: String
    var disabled: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // gap-2
            LabelView(text: label, isDisabled: disabled)
                
            TextField(name, text: $value, prompt: promptView, axis: axis)
                .focused($isFocused)
                .disabled(disabled)
                .tailwindInputStyle(
                    isFocused: isFocused,
                    isInvalid: !isValid,
                    isDisabled: disabled
                )
                .foregroundStyle(Color.theme.foreground)
                .tint(Color.theme.inputRing) // focus-visible:ring-ring
                .autocorrectionDisabled()
                .onChange(of: value) { _, newValue in
                    let filteredValue = filterValue(newValue)
                    if filteredValue != newValue {
                        self.value = filteredValue
                    }
                    validate(filteredValue)
                }
            
            if !isValid && !message.isEmpty {
                Text(message)
                    .foregroundColor(Color.theme.destructive)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var promptView: Text {
        Text(name)
            .foregroundColor(Color.theme.inputText) // maps to muted-foreground
    }
    
    private func validate(_ value: String) {
        for validator in validators {
            if !validator.fn(value) {
                self.isValid = false
                self.message = validator.message
                self.status = .error
                return
            }
        }
        self.isValid = true
        self.message = ""
        self.status = .valid
    }

    private func filterValue(_ value: String) -> String {
        guard !regex.isEmpty else { return value }
        let allowedPattern = "^(?:\(regex))$"
        return String(value.filter { character in
            String(character).range(of: allowedPattern, options: .regularExpression) != nil
        })
    }
}

private struct LabelView: View {
    let text: String
    let isDisabled: Bool
    
    var body: some View {
        Text(text)
            .font(.subheadline) // text-sm
            .fontWeight(.medium) // font-medium
            .foregroundStyle(Color.theme.foreground)
            .opacity(isDisabled ? 0.5 : 1.0)
    }
}


#Preview {
    @Previewable
    @State var value: String = ""
    
    VStack(spacing: 20) {
        TextInput(name: "hello@reportamelo.app", label: "Email", value: $value)
        
        TextInput(name: "hello@reportamelo.app", label: "Invalid State", validators: [
            Validator(name: "error", message: "This is an error", fn: { _ in false })
        ], value: .constant("error"))
        
        TextInput(name: "hello@reportamelo.app", label: "Disabled State", value: .constant(""), disabled: true)
    }
    .padding()
}
