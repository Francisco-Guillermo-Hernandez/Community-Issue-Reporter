//
//  Report.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
//

import Foundation

struct Report: Identifiable, Codable {
    let id: String
    let coordinate: [String]
    let address: String
    let description: String
    let severityId: Int
    let statusId: Int
    let issueTypeId: Int
    let matterToSolveId: Int
    let reportedAt: Date
    let cellIndex: String
    let createdAt: Date
    let updatedAt: Date
    let reportedBy: String

    var latitude: Double? {
        guard let value = coordinate.first else {
            return nil
        }
        return Double(value)
    }

    var longitude: Double? {
        guard coordinate.count > 1 else {
            return nil
        }
        return Double(coordinate[1])
    }
}
