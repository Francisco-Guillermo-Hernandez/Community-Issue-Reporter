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
    var axis: Axis
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .frame(height: axis == .vertical ? 60 : 36)
            .font(.system(size: 14)) // md:text-sm
            .background(
                colorScheme == .dark ? Color.theme.inputBackground.opacity(0.3) : Color.clear
            )
            .clipShape(shapeMask)
            .contentShape(shapeMask)
            .overlay(
                shapeMask
                    .stroke(
                        isInvalid ? Color.theme.destructive : (isFocused ? Color.theme.inputRing : Color.theme.inputBorder),
                        lineWidth: 1
                    )
            )
            .opacity(isDisabled ? 0.5 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isFocused)
            .animation(.easeOut(duration: 0.2), value: isInvalid)
    }
    
    var shapeMask: AnyShape {
        if axis == .vertical {
            return AnyShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
        } else {
            return AnyShape(Capsule())
        }
    }
    
}

extension View {
    func tailwindInputStyle(isFocused: Bool, isInvalid: Bool, isDisabled: Bool, axis: Axis) -> some View {
        self.modifier(TailwindInputModifier(isFocused: isFocused, isInvalid: isInvalid, isDisabled: isDisabled, axis: axis))
    }
}


enum RegexType: Equatable {
    case customPattern(String)
    case email
}

struct TextInput: View {
    var name: String
    var label: String
    var validators: [Validator]
    var regex: RegexType
    var axis: Axis
    
    @State private var message: String
    @Binding var isValid: Bool
    @State private var status: TextInputStatus = .untouched
    @Binding var value: String
    var disabled: Bool = false
    
    @FocusState private var isFocused: Bool
    
    init(name: String = "placeholder",
         label: String = "label",
         validators: [Validator] = [],
         regex: RegexType = .customPattern("[a-zA-Z0-9,\\u00C0-\\u00FF ]"),
         axis: Axis = .horizontal,
         message: String = "",
         status: TextInputStatus = .untouched,
         isValid: Binding<Bool>,
         value: Binding<String>,
         disabled: Bool = false
    ) {
        self.name = name
        self.label = label
        
        var initialValidators = validators
        if regex == .email {
            initialValidators.append(contentsOf: emailValidator)
        }
        self.validators = initialValidators
        
        self.regex = regex
        self.axis = axis
        self._message = State(initialValue: message)
        self._status = State(initialValue: status)
        self._isValid = isValid
        self._value = value
        self.disabled = disabled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 2) { // gap-2
            LabelView(text: label, isDisabled: disabled)
                
            TextField(name, text: $value, prompt: promptView, axis: axis)
                .focused($isFocused)
                .disabled(disabled)
                .tailwindInputStyle(
                    isFocused: isFocused,
                    isInvalid: !isValid,
                    isDisabled: disabled,
                    axis: axis
                )
                .foregroundStyle(Color.theme.foreground)
                .tint(Color.theme.inputRing) // focus-visible:ring-ring
                .autocorrectionDisabled()
                .onChange(of: value) { _, newValue in
                    let filtered = regex == .email ? newValue : filterValue(newValue)
                    
                    if filtered != newValue {
                        self.value = filtered
                    }
                    
                    validate(filtered)
                }
            
            if !isValid && !message.isEmpty {
                Text(message)
                    .foregroundColor(Color.theme.destructive)
                    .font(.caption)
                    .padding(.leading, 12)
            }
        }
        .padding(.vertical, 4)
        .task {
            validate(value)
        }
    }
    
    private var promptView: Text {
        Text(name)
            .foregroundColor(Color.theme.inputText) // maps to muted-foreground
    }
    
    /// Lets use the validations to check the text
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
        
       if case let .customPattern(regex) = regex {
           let allowedPattern = "^(?:\(regex))$"
           return String(value.filter { character in
               String(character).range(of: allowedPattern, options: .regularExpression) != nil
           })
        }
        
        return value
    }
}

private struct LabelView: View {
    let text: String
    let isDisabled: Bool
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(Color.theme.foreground)
            .opacity(isDisabled ? 0.4 : 0.75)
            .padding(.leading, 12)
    }
}


#Preview {
    @Previewable
    @State var value: String = ""
    
    @Previewable
    @State var isValid: Bool = false
    
    VStack(spacing: 20) {
        TextInput(name: "hello@reportamelo.app", label: "Email", regex: .email, isValid: $isValid, value: $value,)
        
        TextInput(name: "hello@reportamelo.app", label: "Invalid State", validators: [
            Validator(name: "error", message: "This is an error", fn: { _ in false })
        ], isValid: .constant(false), value: .constant("error"))
        
        TextInput(name: "hello@reportamelo.app", label: "Disabled State", isValid: .constant(true), value: .constant(""), disabled: true)
        
        TextInput(name: "Address", axis: .vertical, isValid: .constant(true), value: .constant("lorem ipsum  dosllsl sllslsl slslslls lslslsl sllsls slllls sllllslslslllslsllslsllsllslsllslsl"))
    }
    .padding()
}
