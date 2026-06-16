//
//  TermAndConditionsLinks.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct LinksView: View {
    var underlinedMarkdown: AttributedString {
        let rawMarkdown = String(localized: "By continuing, you agree to our [Terms of Service](https://reportamelo.app/legal/terms) and [Privacy Policy](https://reportamelo.app/legal/privacy).")
        
        // Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        // Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                // Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
            }
        }
        
        return attributedString
    }

    var body: some View {
        Text(underlinedMarkdown)
            .font(.footnote)
            .foregroundColor(.secondary)
            .tint(Color.theme.primary.mix(with: .white, by: 0.1))
            .frame(maxWidth: .infinity, alignment: .center)
            .kerning(-0.2)
    }
}


#Preview {
    LinksView()
}
