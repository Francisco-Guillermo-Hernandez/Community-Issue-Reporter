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
    let profileId: String
}

struct User: Codable {
    let username: String
    let avatar: String
    let profileId: String
    
    init(username: String, avatar: String, profileId: String) {
        self.username = username
        self.avatar = avatar
        self.profileId = profileId
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
            ForEach(users, id: \.profileId) { user in
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
            HStack(alignment: .center, spacing: .themeSpacing * 3) {
                VStack {
                    Image("user_b")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .clipShape(.circle)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: .themeSpacing) {
                        Text("John Doe")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(userAlias("john.doe"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Yesterday at 20:20 - San Salvador, SV")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
