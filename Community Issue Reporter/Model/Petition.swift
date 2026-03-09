//
//  Petition.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct Petition: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let targetSignatures: Int
    let currentSignatures: Int
    let categoryId: Int
    let statusId: Int
    let reportedBy: UUID
    let disabled: Bool
    let createdAt: Date
    let updatedAt: Date
}
