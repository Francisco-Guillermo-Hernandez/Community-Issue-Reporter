//
//  PostPublisher.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct UserProfile {
    let username: String?
    let avatar: URL?
    let email: String?
}

struct User: Identifiable {
    let id: String?
    let username: String
    let avatar: String
    
    init(id: String? = nil, username: String, avatar: String) {
        self.id = UUID().uuidString as String?
        self.username = username
        self.avatar = avatar
    }
}

struct AvatarView: View {
    var user: User
    var body: some View {
        Image("user")
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(.circle)
    }
}

struct Signatories: View {
    var users: [User]
    var body: some View {
        HStack(spacing: -.themeSpacing * 3) {
            ForEach(users) { user in
                AvatarView(user: user)
                    .overlay(
                        Circle().stroke(Color.theme.border, lineWidth: 1)
                    )
            }
        }
    }
}

struct PostPublisher: View {
    var body: some View {
        Group {
            HStack(alignment: .top, spacing: .themeSpacing * 3) {
                VStack {
                    Image("user_b")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .clipShape(.circle)
                }
                
                VStack {
                    Text("John Doe")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Yesterday at 20:20 - San Salvador, SV")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PostPublisher()
}
