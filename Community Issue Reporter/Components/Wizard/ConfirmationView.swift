//
//  ConfirmationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI
import UIKit

struct ConfirmationView: View {
    @State private var showCopiedCodeMicroInteraction: Bool = false
    
    @Binding var id: String
    @Binding var url: String
    var body: some View {
        VStack(spacing: .themeSpacing * 6) {
            VStack(spacing: .themeSpacing * 4) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 56))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.white,
                        Color.green,
                        Color.green
                    )
                
                Text(String(localized: "Your report has been submitted"))
                    .font(.title2)
                    .bold()
                    
                Text(String(localized: "Please wait for the report to be reviewed. \n We will notify you in each step of the process."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                   
                Text(String(localized: "Response time can vary depending on the institution, severity and type of the report."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(String(localized: "Meanwhile, you can copy report code or share it with others."))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    
            }
            
            VStack(spacing: .themeSpacing * 3) {
                VStack {
                    Text(id)
                        .font(.system(.caption, design: .monospaced))
                        .kerning(0.69)
                        .textSelection(.enabled)
                        .accessibilityIdentifier("report-code-text")
                        .id(id)
                    
                }
                .padding()
                .padding(.horizontal)
                .background(Color.theme.cardBackground)
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
                .glassEffect( in: RoundedRectangle(cornerRadius: .themeRadius * 1, style: .continuous))
                
                HStack {
                    ThemedButton(
                        message: message,
                        action: copyToPasteboard,
                        type: .outline,
                        style: .normal,
                        icon: icon
                    )
                    .accessibilityIdentifier("copy-report-code")
                    
                    ThemedButton(
                        message: "Share Report",
                        action: {
                            shareFromClosure(item: urlFromString(url)!)
                        },
                        type: .outline,
                        style: .normal,
                        icon: "square.and.arrow.up"
                    )
                    .accessibilityIdentifier("share-report")
                }
                    
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
    
    // MARK: - Logic
    
    private var message: String {
        showCopiedCodeMicroInteraction ? "Copied!" : "Copy report code"
    }
    
    private var icon: String {
        showCopiedCodeMicroInteraction ? "checkmark" : "document.on.document"
    }
    
    private func copyToPasteboard() -> Void {
        UIPasteboard.general.string = id
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
          showCopiedCodeMicroInteraction = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                showCopiedCodeMicroInteraction = false
            }
        }
    }
}

#Preview {
    @Previewable
    @State var code: String = "SV-SS-20260619-ro7kMoZIYwqoD0XL"
    
    @Previewable
    @State var shareLink: String = "/hOJgzH9zfAKHeToZ/report/20260701/SS/SV/arboles-caidos"
    
    NavigationStack {
       ScrollView {
           ConfirmationView(id: $code, url: $shareLink)
        }
       .background(Color.theme.background)
    }
    
}
