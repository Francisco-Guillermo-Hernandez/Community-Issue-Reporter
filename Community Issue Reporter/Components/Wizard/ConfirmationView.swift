//
//  ConfirmationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct ConfirmationView: View {
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
                Text("SV-SS-20260616-cUqEVWHYJ9AmXOZ1")
                    .font(.system(.caption, design: .monospaced))
                    .kerning(0.5)
                
                Button(role: .confirm) {
                    
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 10))
                }
                
//                Image(systemName: "document.on.document")
            }
                                .padding()
//            .padding(.horizontal, 16)
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
    ConfirmationView()
}
