//
//  TermAndConditionsLinks.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

enum LinkType {
    case full
    case privacy
}

struct LinksView: View {
    @State private var webViewURL = URL(string: "https://reportamelo.app/legal/terms")
    @State private var showWebView = false
    
    var mode: LinkType = .full
    
    var underlinedMarkdown: AttributedString {
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
            }
        }
        
        return attributedString
    }

    var body: some View {
        Text(mode == .full ? underlinedMarkdown : privacyMarkdown)
            .font(.footnote)
            .foregroundColor(.secondary)
            .tint(Color.theme.primary.mix(with: .white, by: 0.1))
            .frame(maxWidth: .infinity, alignment: .center)
            .kerning(-0.2)
            .environment(\.openURL, OpenURLAction { url in
                print("[debug]: Opening URL: \(url)")
                webViewURL = url
                showWebView = true
                return .handled
            })
            .sheet(isPresented: $showWebView) {
                WebBrowserView(url: $webViewURL)
            }
    }
}


#Preview {
    LinksView()
    
    Divider()
    
    LinksView(mode: .privacy)
}
