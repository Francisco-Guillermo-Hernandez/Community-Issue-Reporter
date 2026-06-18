//
//  TimeLineModels.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import Foundation

struct IssueReport: Codable {
    let status: String
    let id: String
    let history: IssueHistory
}

struct IssueHistory: Codable {
    let reported: Milestone?
    let confirmed: Milestone?
    let inProgress: InProgressMilestone?
    let fixed: Milestone?
}

struct Milestone: Codable {
    var date: String?
    var by: String?
    var comments: String?
    var attachments: [Attachment]?
    var computedConfirmationDate: String? { date }
}

struct InProgressMilestone: Codable {
    let assignedInstitution: String
    let updates: [IssueUpdate]
}

struct IssueUpdate: Codable, Identifiable {
    let id: String
    let date: String
    let by: String
    let comments: String
    let status: String
    let attachments: [Attachment]
}

enum AttachmentType: String, Codable {
    case image
    case video
    case document
}

enum AttachmentValidatedBy: String, Codable {
    case bot
    case municipality
    case citizen
    case manually
}

enum ReportAttachmentState: String, Codable {
    case confirmed
    case pending
    case inappropriate
    case deleted
}

struct Attachment: Codable, Identifiable {
    let id: String
    let type: AttachmentType
    let createdAt: Date
    let updatedAt: Date?
    let uploadedBy: String
    let ValidatedAt: Date?
    let validatedBy: AttachmentValidatedBy?
    let state: ReportAttachmentState
    let notes: String
    let url: String
    let previewUrl: String
}

struct PreviewAttachment: Codable, Identifiable {
    let id: String
    let type: AttachmentType
    let createdAt: Date
    let uploadedBy: String
    let validatedBy: AttachmentValidatedBy?
    let url: String
}
