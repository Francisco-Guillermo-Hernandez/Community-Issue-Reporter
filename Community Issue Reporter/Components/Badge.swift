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
    let icon: String
}

enum BadgeStates: String {
    case disabled
    case enabled
}

struct CustomBadgeView: View {
    @Environment(\.colorScheme) var colorScheme
    var badge: Badge
    var state: BadgeStates = .enabled
    var body: some View {
        
        HStack {
            Image(systemName: badge.icon)
                .foregroundStyle(Color.secondary)

            Text(badge.title)
                .fixedSize()
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
        .frame(height: 24)
        .foregroundStyle(Color.clear)
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(
            Capsule()
//                .fill(Color.clear)
//                .fill(badge.color)
                .fill(Color.theme.cardBackground)
                .glassEffect(in: .capsule)
//                .brightness(colorScheme == .dark ? (-0.9) : 1)
        )
        .overlay {
            Capsule()
                .stroke(badge.color.opacity(0.7), lineWidth: 1)
        }
        
    }
}


#Preview {
    HStack {
        CustomBadgeView(badge: Badge(color: .orange, title: "users", icon: "person.fill"))
        CustomBadgeView(badge: Badge(color: .orange, title: "building", icon: "building"))
    }
}
