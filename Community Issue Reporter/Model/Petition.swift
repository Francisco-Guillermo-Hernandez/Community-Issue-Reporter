//
//  Petition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct Petition: Identifiable, Codable, Equatable {
    var id: String?
    var title: String
    var description: String
    var targetSignatures: Int
    var currentSignatures: Int?
    var categoryId: Int
    var statusId: Int?
    var reportedBy: UUID?
    var disabled: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
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

extension Petition {
    
    var category: Categories {
        
        get {
            Categories.allCases.first(where: { $0.identifier == self.categoryId }) ?? .emergency
        }
        
        set {
            self.categoryId = newValue.identifier
        }
    }
}
