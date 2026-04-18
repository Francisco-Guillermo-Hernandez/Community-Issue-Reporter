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

struct Attachment: Codable, Identifiable {
    let id: String
    let type: String
    let url: String
}
