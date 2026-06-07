//
//  CommentRow.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

// MARK: - Comment row
struct CommentRow: View {
    var comment: Comment
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                
                
                Group {
                    if let URL = urlFromString(comment.profilePicture) {
                        CachedAsyncImage(url: URL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .id(URL)
                    } else {
                        Circle()
                            .fill(.fill)
                    }
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(comment.userName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                    }
                    
                    Text(userAlias(comment.userName))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 0)
                
                Text(formatRelativeDate(from: comment.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            
            Text(comment.message)
//                .font(.body)
                .font(.caption)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Divider()
    }
    
    private func userAlias(_ userName: String) -> String {
        return [
            "~",
            userName
                .lowercased()
                .split(separator: " ")
                .joined(separator: ".")
        ].joined()
    }
}


#Preview {
    
    let comment = Comment(
        id: "1",
        userName: "John Doe",
        profilePicture: "https://development-api.reportamelo.app/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg?v=192929292",
        commentFor: .report,
        resourceId: "",
        message: "We have problems with potholes in the road",
        createdAt: Date(),
        updatedAt: Date()
    )
    
    CommentRow(comment: comment)
}
