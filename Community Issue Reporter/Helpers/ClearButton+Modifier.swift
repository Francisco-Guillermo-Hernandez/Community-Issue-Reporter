//
//  ClearButton+Modifier.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/4/26.
//

import SwiftUI

struct ClearButtonModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .padding(.trailing, text.isEmpty ? 0 : 8)
            .overlay(alignment: .trailing) {
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "delete.left.fill")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    .buttonStyle(.plain)
//                    .padding(.trailing, 8)
                }
            }
    }
}
