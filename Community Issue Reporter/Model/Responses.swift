//
//  Responses.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/3/26.
//

import Foundation

/// Generic Customizable Response
struct CustomizedResponse<T: Decodable>:  Decodable {
    let message: String
    let code: String
    let data: T
    
    init(message: String, code: String, data: T) {
        self.message = message
        self.code = code
        self.data = data
    }
}

struct AvatarResponse: Decodable {
    let avatarUrl: String
}

struct ReportSessionResponse: Codable {
    let reportContainer: String
    let createdAt: Date
    let shareIndexHash: String
    let reportCreationOn: String
}

struct GenericResponse: Identifiable, Codable {
    var id: String
    var message: String
    var code: String
}

///
struct UserTokens: Decodable {
    let queryActionsToken: String
    let mutationActionsToken: String
}

struct ReportLocatorSettings: Decodable {
    let countryCode: String
    let cityId: String
}

///
struct Settings: Decodable {
    let notifications: Notifications
    let privacySettings: PrivacySettings
    let avatarCreatedFrom: AvatarCreatedFrom
    let reportLocatorSettings: ReportLocatorSettings
}

///
struct PublicUserData: Decodable {
    let userName: String
    let names: String
    let email: String
    let profilePicture: String
    let sessionDuration: Int
    let userType: UserType
    let settings: Settings
    let landingPageCompleted: Bool
}

///
struct LoginWithOAuthProviderResponse: Decodable {
    let code: String
    let authSessionId: String
    let authProvider: String
    let publicUserData: PublicUserData
}

///  Paginated Response where T change
struct PaginatedResponse<T: Decodable>: Decodable {
    let documents: [T]?
    let total: Int?
    let page: Int?
    let documentsPerPage: Int?
    let totalPages: Int?
    let hasNext: Bool
    let hasPrev: Bool
    
    init(
        documents: [T]? = [],
        total: Int? = nil,
        page: Int? = nil,
        documentsPerPage: Int? = nil,
        totalPages: Int? = nil,
        hasNext: Bool = false,
        hasPrev: Bool = false
    ) {
        self.documents = documents
        self.total = total
        self.page = page
        self.documentsPerPage = documentsPerPage
        self.totalPages = totalPages
        self.hasNext = hasNext
        self.hasPrev = hasPrev
    }
}


struct BasicInfo: Identifiable, Decodable {
    let id: String
    let ids: [String]
}

struct DaySummary: Decodable {
    let count: Int
    let reports: [BasicInfo]
    let signatures: [BasicInfo]
}

struct InsightsResponse: Decodable {
    let activityDays: [String: DaySummary]
    let totalReports: Int
    let totalSignatures: Int
}

struct Notifications: Encodable, Decodable {
    var app: Bool
    var email: Bool
    var web: Bool
}

struct PrivacySettings: Encodable, Decodable {
    var showMyProfile: Bool
    var showMyUseNameWhenShare: Bool
}
