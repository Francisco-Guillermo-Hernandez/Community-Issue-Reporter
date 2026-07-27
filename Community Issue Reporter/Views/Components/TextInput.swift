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
    case touched
}

struct TailwindInputModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @FocusState.Binding var isFocused: Bool
    var hasError: Bool
    var value: String
    var isDisabled: Bool
    var axis: Axis
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle( Color.theme.foreground)
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
                        hasError ? Color.theme.destructive : (isFocused ? Color.theme.inputRing : Color.theme.inputBorder),
                        lineWidth: 1
                    )
            )
            .opacity(opacity)
            .animation(.easeOut(duration: 0.2), value: isFocused)
            .animation(.easeOut(duration: 0.2), value: hasError)
    }
    
    var shapeMask: AnyShape {
        if axis == .vertical {
            return AnyShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
        } else {
            return AnyShape(Capsule())
        }
    }
    
    var opacity: Double {
        if isDisabled {
            return 0.5
        } else if value.isEmpty {
            return 0.75
        } else {
            return 1
        }
    }
}

extension View {
    func tailwindInputStyle(
        isFocused: FocusState<Bool>.Binding,
        hasError: Bool,
        value: String,
        isDisabled: Bool,
        axis: Axis
    ) -> some View {
        self.modifier(
            TailwindInputModifier(
                isFocused: isFocused,
                hasError: hasError,
                value: value,
                isDisabled: isDisabled,
                axis: axis
            )
        )
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
    var resetTrigger: AnyHashable?
    
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
         isValid: Binding<Bool>,
         value: Binding<String>,
         disabled: Bool = false,
         resetTrigger: AnyHashable? = nil
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
        self._isValid = isValid
        self._value = value
        self.disabled = disabled
        self.resetTrigger = resetTrigger
        
//        preCheck()
    }
    
    
    func preCheck() {
        if self.status == .untouched && value == "" {
            
            print("check")
            self.isValid = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 2) { // gap-2
            LabelView(text: label, isDisabled: disabled)
            
            TextField(name, text: $value, prompt: promptView, axis: axis)
                .focused($isFocused)
                .disabled(disabled)
                .onChange(of: isFocused) { _, newValue in
                    if newValue && status == .untouched {
                        status = .touched
                        validate(value)
                    }
                }
                .tailwindInputStyle(
                    isFocused: $isFocused,
                    hasError: !isValid && status != .untouched,
                    value: value,
                    isDisabled: disabled,
                    axis: axis
                )
                .foregroundStyle(Color.theme.foreground)
                .tint(Color.theme.inputRing) // focus-visible:ring-ring
                .autocorrectionDisabled()
                .onChange(of: value) { _, newValue in
                    if status == .untouched {
                        status = .touched
                    }
                    filter(newValue)
                }
            
            if !isValid && !message.isEmpty && status != .untouched {
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
        .onChange(of: resetTrigger) { _, _ in
            Task { @MainActor in
                status = .untouched
                validate(value)
            }
        }
    }
    
    private func filter(_ newValue: String) {
        let filtered = regex == .email ? newValue : filterValue(newValue)
        
        if filtered != newValue {
            self.value = filtered
        }
        
        validate(filtered)
    }
    
    private var promptView: Text {
        Text(name)
            .foregroundColor(Color.theme.inputText) // maps to muted-foreground
    }
    
    /// Lets use the validations to check the text
    private func validate(_ value: String) {
        let wasUntouched = (status == .untouched)
        
        for validator in validators {
            if !validator.fn(value) {
                self.isValid = false
                self.message = validator.message
                if !wasUntouched {
                    self.status = .error
                }
                return
            }
        }
        self.isValid = true
        self.message = ""
        if !wasUntouched {
            self.status = .valid
        }
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

struct LabelView: View {
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

enum TestFieldsMock: Hashable {
    case email
    case invalidEmail
    case disabledEmail
    case randomText
}

#Preview {
    @Previewable
    @State var value: String = ""
    
    @Previewable
    @State var isValid: Bool = false
    
    @State var resetId: UUID = UUID()
    
    VStack(spacing: 20) {
        TextInput(name: "hello@reportamelo.app", label: "Email", regex: .email, isValid: $isValid, value: $value, resetTrigger: resetId)
        
        Button("Clear & Reset Form") {
                            value = ""
                            resetId = UUID() // Changing the trigger resets the untouched state
                        }
        
        TextInput(name: "hello@reportamelo.app", label: "Invalid State", validators: [
            Validator(name: "error", message: "This is an error", fn: { _ in false })
        ], isValid: .constant(false), value: .constant("error"))
        
        TextInput(name: "hello@reportamelo.app", label: "Disabled State", isValid: .constant(true), value: .constant(""), disabled: true)
        
        TextInput(name: "Address", axis: .vertical, isValid: .constant(true), value: .constant("lorem ipsum  dosllsl sllslsl slslslls lslslsl sllsls slllls sllllslslslllslsllslsllsllslsllslsl"))
    }
    .padding()
}
