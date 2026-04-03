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

struct TextInput: View {
    var name: String = "placeholder"
    var label: String = "label"
    var validators: [Validator] = []
    var regex: String = "[a-zA-Z0-9, ]"
    
    @State private var message: String = ""
    @State private var isValid: Bool = false
    @State private var status: TextInputStatus = .untouched
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            TextField(name, text: $value)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(self.status.color, lineWidth: 2)
                )
                .onChange(of: value) { _, newValue in
                    let filteredValue = filterValue(newValue)
                    if filteredValue != newValue {
                        self.value = filteredValue
                    }
                    self.isValid = checkValidations(filteredValue)
                }
                
                
            
            if !isValid {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
        }
        .listRowSeparator(.hidden)
        .padding(0)
    }
    
    private func checkValidations(_ value: String) -> Bool {
        
        var result: Bool = false
        for validator in validators {
            result = validator.fn(value)
            if !result {
                self.status = .error
                self.message = validator.message
                break
            } else {
                self.status = .valid
                self.message = ""
            }
        }
        
        return result
    }

    private func filterValue(_ value: String) -> String {
        guard !regex.isEmpty else { return value }

        let allowedPattern = "^(?:\(regex))$"
        return String(value.filter { character in
            String(character).range(of: allowedPattern, options: .regularExpression) != nil
        })
    }
}

#Preview {
    @Previewable
    @State var value: String = ""
    
    TextInput(validators: titleValidator, value: $value)
}
