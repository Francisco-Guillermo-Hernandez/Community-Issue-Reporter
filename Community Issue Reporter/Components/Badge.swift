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

struct CustomBadgeView: View {
    var badge: Badge
    var body: some View {
        
        HStack {
            Image(systemName: badge.icon)
                .tint(.white)
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(height: 24)
        .foregroundStyle(Color.white)
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(
            Capsule()
                .fill(badge.color)
                .glassEffect(in: .capsule)
                .brightness(-0.2)
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
