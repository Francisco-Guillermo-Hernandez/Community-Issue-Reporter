//
//  Petition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation
import SwiftUI
import Observation

enum PostVisibility: String, Codable {
    case hidden
    case draft
    case published
}

struct PostMetadata: Codable {
    let audience: String
    let visibility: PostVisibility
    let countryCode: CountryCode
    let language: String
    let shareLink: String
}

struct ReportMetadata: Identifiable, Codable {
    let id: String
    let lat: Double
    let lng: Double
    let created: Date
    let severityId: Int
    let statusId: Int
    let issueTypeId: Int
    let matterToSolveId: Int
}

struct PostSigners: Decodable {
    var hasCurrentUserSigned: Bool
    let latestsSigners: [User]
    
    init(hasCurrentUserSigned: Bool = false, latestsSigners: [User] = []) {
        self.hasCurrentUserSigned = hasCurrentUserSigned
        self.latestsSigners = latestsSigners
    }
}

@Observable
class Petition: Codable {
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
    var reportsIds: [String]
    
    init(
        id: String? = nil,
        title: String,
        description: String,
        targetSignatures: Int,
        currentSignatures: Int?,
        categoryId: Int,
        statusId: Int?,
        reportedBy: UUID?,
        disabled: Bool?,
        createdAt: Date?,
        updatedAt: Date?,
        reportsIds: [String] = [],
    ) {
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
        self.reportsIds = reportsIds
    }
}

class PetitionPost: Identifiable, Decodable, Equatable, Hashable {
    
    static func == (lhs: PetitionPost, rhs: PetitionPost) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    let title: String
    let description: String
    let targetSignatures: Int
    let currentSignatures: Int
    let categoryId: Int
    let statusId: Int
    let reportedBy: UUID?
    let disabled: Bool
    let createdAt: Date
    let updatedAt: Date?
    let reportsIds: [String]
    let attachments: [Attachment]
    let postMetadata: PostMetadata
    let postPublisher: User
    let reportsMetadata: [ReportMetadata]
    let postSigners: PostSigners
    let progress: Double
    
    init(
        id: String,
        title: String,
        description: String,
        targetSignatures: Int,
        currentSignatures: Int,
        categoryId: Int,
        statusId: Int,
        reportedBy: UUID?,
        disabled: Bool,
        createdAt: Date,
        updatedAt: Date?,
        reportsIds: [String] = [],
        attachments: [Attachment] = [],
        postMetadata: PostMetadata,
        postPublisher: User,
        reportsMetadata: [ReportMetadata] = [],
        postSigners: PostSigners,
        progress: Double,
    ) {
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
        self.reportsIds = reportsIds
        self.attachments = attachments
        self.postMetadata = postMetadata
        self.postPublisher = postPublisher
        self.reportsMetadata = reportsMetadata
        self.postSigners = postSigners
        self.progress = progress
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
    
    var status: IssueStatus {
        get {
            IssueStatus.allCases.first(where: { $0.identifier == self.statusId }) ?? .inProgress
        }
        
        set {
            self.statusId = newValue.identifier
        }
    }
    
    var updateSignatures: Int {
        
        get {
            self.targetSignatures
        }
        
        set {
            self.targetSignatures = newValue
        }
    }
}

extension PetitionPost {
    var category: Categories {
        
        get {
            Categories.allCases.first(where: { $0.identifier == self.categoryId }) ?? .emergency
        }
    }
    
    var status: IssueStatus {
        get {
            IssueStatus.allCases.first(where: { $0.identifier == self.statusId }) ?? .inProgress
        }
    }
    
    var updateSignatures: Int {
        
        get {
            self.targetSignatures
        }
        
    }
    
    var percentage: String {
        get {
            String(format: "%.2f%%", self.progress)
        }
    }
    
}
