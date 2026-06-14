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
    let name: String
    let userName: String
    let profilePicture: String
    let commentFor: CommentForType
    let resourceId: String
    let message: String
    var createdAt: Date
    var updatedAt: Date?
    
    init(
        id: String?,
        name: String,
        userName: String,
        profilePicture: String,
        commentFor: CommentForType,
        resourceId: String,
        message: String,
        createdAt: Date,
        updatedAt: Date?
    ) {
        self.id = id
        self.name = name
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
        self.profilePicture = ""
        self.name = UserRepository.shared.getName()
        self.userName = UserRepository.shared.getUsername()
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
