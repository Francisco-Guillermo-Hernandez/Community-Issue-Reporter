//
//  Comment.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import Foundation

enum CommentForType: String, Codable {
    case report
    case petition
}

struct Comment: Identifiable, Codable {
    var id: String?
    let userName: String
    let profilePicture: String
    let commentFor: CommentForType
    let resourceId: String
    let message: String
    var createdAt: Date
    var updatedAt: Date?
    
    init(
        id: String?,
        userName: String,
        profilePicture: String,
        commentFor: CommentForType,
        resourceId: String,
        message: String,
        createdAt: Date,
        updatedAt: Date?
    ) {
        self.id = id
        self.userName = userName
        self.profilePicture = profilePicture
        self.commentFor = commentFor
        self.resourceId = resourceId
        self.message = message
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    init(
        commentFor: CommentForType,
        resourceId: String,
        message: String,
    ) {
        self.id = UUID().uuidString
        self.userName = "Guest"
        self.profilePicture = "https://development-api.reportamelo.app/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg?v=192929292"
        self.commentFor = commentFor
        self.resourceId = resourceId
        self.message = message
        self.createdAt = Date()
        self.updatedAt = nil
    }
}

struct CommentRequest: Codable {
    let reportId: String
    let message: String
}
