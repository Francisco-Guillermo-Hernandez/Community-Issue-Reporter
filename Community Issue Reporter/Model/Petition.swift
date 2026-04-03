//
//  Petition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct Petition: Identifiable, Codable {
    let id: String?
    let title: String
    let description: String
    let targetSignatures: Int
    let currentSignatures: Int?
    let categoryId: Int
    let statusId: Int?
    let reportedBy: UUID?
    let disabled: Bool?
    let createdAt: Date?
    let updatedAt: Date?
    
    init(id: String?, title: String, description: String, targetSignatures: Int, currentSignatures: Int?, categoryId: Int, statusId: Int?, reportedBy: UUID?, disabled: Bool?, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.title = title
        self.description = description
        self.targetSignatures = targetSignatures
        self.currentSignatures = currentSignatures
        self.categoryId = categoryId
        self.statusId = statusId
        self.reportedBy = reportedBy
        self.disabled = disabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
