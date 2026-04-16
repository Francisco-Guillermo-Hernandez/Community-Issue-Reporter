//
//  Comment.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String
    let createdAt: Date
    let name: String
    let message: String
}
