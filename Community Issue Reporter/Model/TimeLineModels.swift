//
//  TimeLineModels.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import Foundation

struct AssignedInstitution: Codable {
    let institutionName: String
    let institutionCode: String
    let institutionId:   String
}

struct ResolutionMetadata: Codable {
    let cityId: String
    let groupingId: String
    let assigned: AssignedInstitution
    let resourceType: String
    let resourceId: String
}

struct Resolution: Codable {
    let status: String
    let id: String
    let history: IssueHistory
    let metadata: ResolutionMetadata
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
    let id: String?
    let date: String
    let by: String
    let comments: String
    let status: String
    let attachments: [Attachment]
    
    init(id: String? = UUID().uuidString, date: String, by: String, comments: String, status: String, attachments: [Attachment]) {
        self.id = id
        self.date = date
        self.by = by
        self.comments = comments
        self.status = status
        self.attachments = attachments
    }
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
    case manualRevision
}

struct Attachment: Codable, Identifiable {
    let id: String?
    let type: AttachmentType
    let createdAtRaw: Int64
    let updatedAtRaw: Int64?
    let uploaderUserName: String
    let validatedAtRaw: Int64?
    let validatedBy: AttachmentValidatedBy?
    let state: ReportAttachmentState
    let notes: String
    let key: String?
    let fileName: String?
    let reportContainer: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "attachmentId"
        case type
        case createdAtRaw = "createdAt"
        case updatedAtRaw = "updatedAt"
        case uploaderUserName
        case validatedAtRaw = "validatedAt"
        case validatedBy
        case state
        case notes
        case key
        case fileName
        case reportContainer
    }
    
    var createdAt: Date {
        return Date(timeIntervalSince1970: Double(createdAtRaw) / 1000.0)
    }
    
    var updatedAt: Date? {
        guard let updatedAtRaw = updatedAtRaw else { return nil }
        return Date(timeIntervalSince1970: Double(updatedAtRaw) / 1000.0)
    }
    
    var validatedAt: Date? {
        guard let validatedAtRaw = validatedAtRaw else { return nil }
        return Date(timeIntervalSince1970: Double(validatedAtRaw) / 1000.0)
    }
    
    var url: String {
        guard let key = key else { return "" }
        if #available(iOS 16.0, *) {
            return Endpoints.baseURL.appending(path: key).absoluteString
        } else {
            return Endpoints.baseURL.appendingPathComponent(key).absoluteString
        }
    }
    
    var previewUrl: String {
        return url
    }
    
    var createdDate: String {
        formatRelativeDate(from: self.createdAt)
    }
}

struct GroupedAttachmentPayload: Codable {
    let attachmentContainer: String
    let key: String
    let previewFileName: String
    let fileName: String
    let reportId: String
    let notes: String
}

struct PreviewAttachment: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let type: AttachmentType
    let createdAtRaw: Int64
    let updatedAtRaw: Int64?
    let uploaderUserName: String
    let validatedBy: AttachmentValidatedBy?
    let state: ReportAttachmentState
    let fileName: String
    let reportContainer: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case createdAtRaw
        case updatedAtRaw
        case uploaderUserName
        case validatedBy
        case state
        case fileName
        case reportContainer
    }
    
    var createdAt: Date { Date(timeIntervalSince1970: Double(createdAtRaw) / miliSeconds) }
    var updatedAt: Date? {
        guard let updatedAtRaw else { return nil }
        return Date(timeIntervalSince1970: Double(updatedAtRaw) / miliSeconds)
    }
    var url: URL? {
        get {
            if !reportContainer.isEmpty && !fileName.isEmpty {
                return buildPreviewAttachmentURL(reportContainer, fileName, state, updatedAtRaw)
            }
            
            return nil
        }
    }
    
    var more: Bool {
        get {
            return false
        }
        
        set {
            if self.id == "placeholder" {
                self.more = true
            }
        }
    }
}


struct PreviewAttachmentRequest: Codable {
    var attachmentId: String
    let fileName: String
    let type: AttachmentType
    let key: String
    let notes: String?
    let reportContainer: String
}

extension PreviewAttachmentRequest {
    var url: URL? {
        get {
            if !reportContainer.isEmpty && !fileName.isEmpty {
                return getURL(from: self.key)
            }
            
            return nil
        }
    }
}
