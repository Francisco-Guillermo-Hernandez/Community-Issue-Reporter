//
//  PostInteractions.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct PostInteractions: View {
    var hasCurrentUserSigned: Bool = false
    var sign: () -> Void
    var comment: () -> Void
    var share: () -> Void
    var body: some View {
        HStack {
            Button(action: sign) {
                Image(systemName: "signature")
                    .font(.title2)
                    .foregroundStyle(hasCurrentUserSigned ? Color.theme.primary : .primary)
                    .fontWeight(.bold)
                    .frame(width: 60, height: 40)
                    .background(Color.black.opacity(0.001))
                    .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            }
            .accessibilityLabel("Sign a petition button")
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)
            
            Button(action: comment) {
                Image(systemName: "text.bubble")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 80, height: 40)
                    .background(Color.black.opacity(0.001))
                    .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)
            
            Button(action: share) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 80, height: 40)
                    .background(Color.black.opacity(0.001))
                    .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    PostInteractions(sign: {}, comment: {}, share: {})
}

#Preview("Signed") {
    PostInteractions(hasCurrentUserSigned: true, sign: {}, comment: {}, share: {})
}
