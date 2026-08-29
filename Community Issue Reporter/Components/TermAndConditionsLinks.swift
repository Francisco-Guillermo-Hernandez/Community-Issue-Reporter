//
//  TermAndConditionsLinks.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

enum LinkType {
    case termsAndConditions
    case full
    case privacy
    case policies
    case endUserLicenseAgreement
}

struct LinksView: View {
    @State private var webViewURL = URL(string: "https://reportamelo.app/legal/terms")
    @State private var showWebView = false
    
    var type: LinkType = .termsAndConditions
    
    var fullMarkdown: AttributedString {
        let rawMarkdown = String(localized: "You can review our [Terms of Service](https://reportamelo.app/legal/terms), [Privacy Policy](https://reportamelo.app/legal/privacy), [EULA](https://reportamelo.app/legal/eula) and [Policies](https://reportamelo.app/legal/policies).")
        
        /// Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        /// Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                /// Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
                attributedString[run.range].font = .system(.footnote, weight: .semibold)
            }
        }
        
        return attributedString
    }
    
    var termsAndConditionsMarkdown: AttributedString {
        let rawMarkdown = String(localized: "By continuing, you agree to our [Terms of Service](https://reportamelo.app/legal/terms) and [Privacy Policy](https://reportamelo.app/legal/privacy).")
        
        /// Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        /// Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                /// Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
                attributedString[run.range].font = .system(.footnote, weight: .semibold)
            }
        }
        
        return attributedString
    }
    
    /// Privacy styling
    var privacyMarkdown: AttributedString {
        let rawMarkdown = String(localized: "If you have doubts about how we use your data, please review our [Privacy Policy](https://reportamelo.app/legal/privacy).")
        
        /// Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        /// Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                /// Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
                attributedString[run.range].font = .system(.footnote, weight: .semibold)
            }
        }
        
        return attributedString
    }
    
    var policiesMarkdown: AttributedString {
        let rawMarkdown = String(localized: "If you have doubts, please review our [Policies](https://reportamelo.app/legal/policies).")
        
        /// Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        /// Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                /// Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
                attributedString[run.range].font = .system(.footnote, weight: .semibold)
            }
        }
        
        return attributedString
    }

    var endUserLicenseAgreementMarkdown: AttributedString {
        let rawMarkdown = String(localized: "If you have doubts, please review our [End User License Agreement](https://reportamelo.app/legal/eula).")
        
        /// Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        /// Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                /// Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
                attributedString[run.range].font = .system(.footnote, weight: .semibold)
            }
        }
        
        return attributedString
    }
    
    var body: some View {
        Text(getLinks(type))
            .font(.footnote)
            .foregroundColor(.secondary)
//            .tint(Color.theme.primary)
            .kerning(-0.1)
            .environment(\.openURL, OpenURLAction { url in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                webViewURL = url
                showWebView = true
                return .handled
            })
            .sheet(isPresented: $showWebView) {
                SafariWebView($webViewURL)
//                WebBrowserView(url: $webViewURL)
            }
    }
    
    private func getLinks(_ type: LinkType) -> AttributedString {
        switch type {
            case .full:
                return fullMarkdown
            case .privacy:
                return privacyMarkdown
            case .policies:
                return policiesMarkdown
            case .endUserLicenseAgreement:
                return endUserLicenseAgreementMarkdown
            case .termsAndConditions:
                return termsAndConditionsMarkdown
            
        }
    }
}


#Preview {
    LinksView()
    
    Divider()
    
    LinksView(type: .privacy)
}
