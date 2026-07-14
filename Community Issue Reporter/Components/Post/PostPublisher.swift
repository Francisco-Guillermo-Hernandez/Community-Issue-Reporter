//
//  PostPublisher.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct UserProfile: Decodable {
    let username: String?
    let avatar: URL?
    let email: String?
    let profileId: String
}

struct User: Decodable {
    let names: String
    let userName: String
    let profilePicture: String
    let profileId: String
    var profilePictureURL: URL? {
        getURL(from: profilePicture)
    }
}

struct AvatarView: View {
    var user: User
    var body: some View {
        if let url = user.profilePictureURL {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 48, height: 48)
            .clipShape(.circle)
            .glassEffect(in: .circle)
            .id(url)

        } else {
            Image("user_b")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(.circle)
                .glassEffect(in: .circle)

        }
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
    var petition: PetitionPost
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: .themeSpacing * 3) {
                VStack {
                    
                    if let url = petition.postPublisher.profilePictureURL {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 48, height: 48)
                        .clipShape(.circle)
                        .glassEffect(in: .circle)
                        .id(url)

                    } else {
                        Image("user_b")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(.circle)
                            .glassEffect(in: .circle)

                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: .themeSpacing) {
                        Text(petition.postPublisher.names)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(userAlias(petition.postPublisher.userName))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(publishedInfo)
                        .font(.caption)
                        .opacity(0.85)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var publishedInfo: String {
        String(format: "%@ - %@, %@",
               petition.createdDate,
               petition.postMetadata.city,
               petition.postMetadata.countryCode.rawValue
        )
    }
}

#Preview {
    let petition = PetitionPost(
        id: "",
        title: "",
        description: "",
        targetSignatures: 0,
        currentSignatures: 0,
        categoryId: 1,
        statusId: 1,
        reportedBy: nil,
        disabled: false,
        createdAt: Date(timeIntervalSince1970: 1783348382158/1000),
        updatedAt: nil,
        reportsIds: [],
        postMetadata: .init(audience: "", visibility: .published, countryCode: .SV, city: "San Salvador", cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619", language: "es", shareLink: ""),
        postPublisher: .init(names: "John Doe", userName: "jonh.doe", profilePicture: "/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg", profileId: "G6abo3sSu1zcQ1U9"),
        postSigners: .init(),
        progress: 10.0
    )
    
    ScrollView {
        PostPublisher(petition: petition)
            .padding(.horizontal)
            .containerRelativeFrame(.vertical)
    }
    .background(Color.theme.background)
}

#Preview("Signers") {
    let users: [User] = [
        User(names: "Jane Doe", userName: "jane.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "uiEw3sSu1zcQ1U9"),
        User(names: "Martha Doe", userName: "martha.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "ieq3sSu1zcQ1U9"),
        User(names: "Michael Brown", userName: "michael.brown", profilePicture: "/avatars/019f4f22-1464-79bc-a712-acf20b7b3664.png", profileId: "l33sSu1zcQ1U9"),
    ]
    
    ScrollView {
        Signatories(users: users)
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical)
    }
    .background(Color.theme.background)
}
