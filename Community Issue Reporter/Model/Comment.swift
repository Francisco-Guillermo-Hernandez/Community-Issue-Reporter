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

struct CommentToBlock: Codable {
    let id: String
    let message: String
    let commentFor: CommentForType
    let resourceId: String
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
    let observation: String?
    let action: String?
    
    init(
        id: String?,
        name: String,
        userName: String,
        profilePicture: String,
        commentFor: CommentForType,
        resourceId: String,
        message: String,
        createdAt: Date,
        updatedAt: Date?,
        observation: String? = nil,
        action: String? = nil
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
        self.observation = observation
        self.action = action
    }
    
    
    init(
        commentFor: CommentForType,
        resourceId: String,
        message: String,
    ) {
        self.id = UUID().uuidString
        self.profilePicture = UserRepository.shared.getProfilePicture()
        self.name = UserRepository.shared.getName()
        self.userName = UserRepository.shared.getUsername()
        self.commentFor = commentFor
        self.resourceId = resourceId
        self.message = message
        self.createdAt = Date()
        self.updatedAt = nil
        self.action = nil
        self.observation = nil
    }
}

struct CommentRequest: Codable {
    let reportId: String
    let message: String
}
