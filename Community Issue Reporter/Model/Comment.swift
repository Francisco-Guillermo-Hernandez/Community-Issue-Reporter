//
//  Comment.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    var created_at: Date?
    var updated_at: Date?
    let name: String?
    let report_id: String
    let message: String
    
    init(
        id: String,
        created_at: Date? = nil,
        updated_at: Date? = nil,
        name: String? = nil,
        report_id: String,
        message: String
    ) {
        self.id = id
        self.created_at = created_at //applyFormat(created_at)
        self.updated_at = updated_at //applyFormat(updated_at)
        self.name = name
        self.report_id = report_id
        self.message = message
    }
}

struct CommentRequest: Codable {
    let reportId: String
    let message: String
}
