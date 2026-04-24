//
//  Badge.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/4/26.
//

import SwiftUI

struct Badge {
    let color: Color
    let title: String
}

struct CustomBadgeView: View {
    var badge: Badge
    var body: some View {
        Capsule()
            .fill(badge.color)
            .glassEffect(in: .capsule)
            .brightness(-0.2)
            .frame(width: 85, height: 24)
            .overlay {
                Text(badge.title)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
    }
}
