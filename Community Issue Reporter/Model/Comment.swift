//
//  Comment.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    var createdAt: Date?
    var updatedAt: Date?
    let name: String?
    let reportId: String
    let message: String
    
    init(
        id: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        name: String? = nil,
        reportId: String,
        message: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.reportId = reportId
        self.message = message
    }
}

struct CommentRequest: Codable {
    let reportId: String
    let message: String
}
