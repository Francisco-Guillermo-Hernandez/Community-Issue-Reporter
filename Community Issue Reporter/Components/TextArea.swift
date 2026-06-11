//
//  TextArea.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/6/26.
//

import SwiftUI

struct TextArea: View {
    
    @State private var text: String = "hello"
    var body: some View {
        TextEditor(text: $text)
            .textInputAutocapitalization(.sentences) // Auto-capitalize first word
              .autocorrectionDisabled(false)
                     .frame(height: 60)
                     .padding(.horizontal, 4)
                     .scrollContentBackground(.hidden)
                     .background(Color.clear)
                     .overlay(
                        RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous)
                                           .stroke(Color.theme.inputBorder, lineWidth: 1)
                    )
                    .cornerRadius(.themeRadius * 1)
        
                    .clipShape(
                        RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                    )
                    .contentShape(
                        RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                    )
    }
}

#Preview {
    TextArea()
}
