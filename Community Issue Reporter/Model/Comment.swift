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
    let profileId: String
    let commentFor: CommentForType
    let resourceId: String
    
    init(id: String, message: String, profileId: String, commentFor: CommentForType, resourceId: String) {
        self.id = id
        self.message = message
        self.profileId = profileId
        self.commentFor = commentFor
        self.resourceId = resourceId
    }
    
    init(_ comment: Comment) {
        self.id = comment.id ?? ""
        self.message = comment.message
        self.profileId = comment.profileId
        self.commentFor = comment.commentFor
        self.resourceId = comment.resourceId
    }
}

struct Comment: Identifiable, Codable {
    var id: String?
    let name: String
    let userName: String
    let profilePicture: String
    let profileId: String
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
        profileId: String,
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
        self.profileId = profileId
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
        self.profileId = "currentUser"
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
