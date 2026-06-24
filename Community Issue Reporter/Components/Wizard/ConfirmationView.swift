//
//  ConfirmationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var id: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundColor(.green)
            
            Text("Ready to Submit")
                .font(.headline)
            
            Text("Please review your report details above. Tap Submit to finalize.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            HStack {
                Text(id)
                    .font(.system(.caption, design: .monospaced))
                    .kerning(0.5)
                    .id(id)
                
                Button(role: .confirm) {
                    
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 10))
                }
                
            }
                                .padding()
                                .background(Color.theme.cardBackground)
        
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
            .glassEffect( in: RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

#Preview {
    @Previewable
    @State var code: String = "SV-SS-20260619-ro7kMoZIYwqoD0XL"
    
    NavigationStack {
        ConfirmationView(id: $code)
    }
    .background(Color.theme.background)
}
