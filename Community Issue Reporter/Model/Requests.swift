//
//  Requests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import Foundation

struct OAuthSignInPayload: Encodable {
    let token: String
}

struct MapExplorerQueryParams: Encodable {
    
    var lat: Double
    var lng: Double
    var radius: Int
    var issueTypeIds: [Int]
    var severityIds: [Int]
    var statusIds: [Int]
}

struct PaginatedRequestQueryParams: Encodable {
    let page: Int?
    let limit: Int?
    var issueTypeId: Int?
    var severityId: Int?
    var countryCode: String?
    var departmentalCapital: Bool?
    var cityName: String?
    var stateName: String?
    var groupingName: String?
    var ordering: String

    init(
        page: Int? = 1,
        limit: Int? = 3,
        issueTypeId: Int? = nil,
        severityId: Int? = nil,
        countryCode: String? = nil,
        departmentalCapital: Bool? = nil,
        cityName: String? = nil,
        stateName: String? = nil,
        groupingName: String? = nil,
        ordering: OrderFilter = .descending
    ) {
        self.page = page
        self.limit = limit
        self.issueTypeId = issueTypeId
        self.severityId = severityId
        self.countryCode = countryCode
        self.departmentalCapital = departmentalCapital
        self.cityName = cityName
        self.stateName = stateName
        self.groupingName = groupingName
        self.ordering = ordering.filter
    }
}

struct LocatorHeaders {
    let headers: Array<HTTPHeader>
}

struct AvatarCreatedFromRequest: Encodable {
    let avatarCreatedFrom: AvatarCreatedFrom
}

struct DefaultReportingCity: Encodable {
    let cityId: String
    
    init(_ cityId: String) {
        self.cityId = cityId
    }
}


struct BlockUserReason: Encodable {
    let profileId: String
    let reason: String
    let blockedReasonId: ReportReason
}

struct ReportContentWithViolation: Encodable {
    let attachment: PreviewAttachment
    let reason: String
    let blockedReasonId: String
}

struct ReportCommentWithViolation: Encodable {
    let comment: CommentToBlock
    let reason: String
    let blockedReasonId: String
}


enum TypeOfContentToReport: String, CaseIterable, Codable {
    case image
    case report
    case video
    case comment
    case petition
    case account
    
    var description: String {
        switch self {
            case .image: return String(localized: "Image")
            case .report: return String(localized: "Report")
            case .video: return String(localized: "Video")
            case .comment: return String(localized: "Comment")
            case .petition: return String(localized: "Petition")
            case .account: return String(localized: "Account")
        }
    }
    
    var icon: String {
        switch self {
            case .image: return "photo"
            case .report: return "exclamationmark.bubble"
            case .video: return "video"
            case .comment: return "text.bubble"
            case .petition: return "bubble.left.and.bubble.right"
            case .account: return "person.crop.circle"
        }
    }
}

enum ReportViolationStatus: String, CaseIterable, Codable {
    case approved
    case rejected
    case pending
    case appealing
    case sentToModeration
    case removed
    
    var description: String {
        switch self {
            case .approved: return String(localized: "Approved")
            case .rejected: return String(localized: "Rejected")
            case .pending: return String(localized: "Pending")
            case .appealing: return String(localized: "Appealing")
            case .sentToModeration: return String(localized: "Sent to Moderation")
            case .removed: return String(localized: "Removed")
        }
    }
}

struct ReportViolation<T: Codable>: Codable {
    let id: String?
    let type: TypeOfContentToReport
    let content: T
    let contentAuthorProfileId: String
    let reason: String
    let blockedReasonId: String
    let status: ReportViolationStatus
    let observation: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    init(
        type: TypeOfContentToReport,
        content: T,
        profileId: String,
        reason: String,
        blockedReasonId: String,
        status: ReportViolationStatus,
    ) {
        self.id = UUID().uuidString
        self.type = type
        self.content = content
        self.contentAuthorProfileId = profileId
        self.reason = reason
        self.blockedReasonId = blockedReasonId
        self.status = status
        self.observation = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    init(
        id: String,
        type: TypeOfContentToReport,
        content: T,
        profileId: String,
        reason: String,
        blockedReasonId: String,
        status: ReportViolationStatus,
        observation: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.contentAuthorProfileId = profileId
        self.reason = reason
        self.blockedReasonId = blockedReasonId
        self.status = status
        self.observation = observation
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
}

struct Voting: Encodable, Decodable {
    let type: VotingType
    let resourceId: String
    
    init(
        type: VotingType,
        resourceId: String
    ) {
        self.type = type
        self.resourceId = resourceId
    }
}
