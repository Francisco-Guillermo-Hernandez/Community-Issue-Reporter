//
//  CheckBox.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/6/26.
//

import SwiftUI

// 1. Define the Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle() // Handle tap action
        } label: {
            HStack {
                // Checkbox graphics using SF Symbols
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .secondary)
                    .font(.system(size: 22))
                
                configuration.label // Pass the original text or view label
            }
        }
        .buttonStyle(.plain) // Disables default button opacity animations
    }
}



struct CheckBox: View {
    @State private var isAgreed = false

        var body: some View {
            VStack {
                Toggle("I agree to the Terms and Conditions", isOn: $isAgreed)
                    .toggleStyle(CheckboxToggleStyle()) // Apply the style here
                    .padding()
            }
        }
}

#Preview {
    CheckBox()
}
