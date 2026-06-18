//
//  Definitions.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import Foundation
import SwiftUI

enum ReportStep: Int, CaseIterable, Comparable {
    case location = 1
    case media = 2
    case details = 3
    case confirmation = 4
    
    static func < (lhs: ReportStep, rhs: ReportStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var metadataKey: String {
        switch self {
        case .location: return "Location"
        case .media: return "Media"
        case .details: return "Details"
        case .confirmation: return "Confirmation"
        }
    }
    
    var color: Color {
        switch self {
        case .location: return Color.theme.primary
        case .media: return Color.theme.primary
        case .details: return Color.theme.primary
        case .confirmation: return .green
        }
    }
}

struct StepsMetadata: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var icon: String
}

let stepsMetadata: [String: StepsMetadata] = [
    "Location": StepsMetadata(title: "Location", description: "Where did it happen?", icon: "location.magnifyingglass"),
    "Media": StepsMetadata(title: "Media", description: "Any photos or videos?", icon: "photo.badge.plus"),
    "Details": StepsMetadata(title: "Details", description: "What happened?", icon: "long.text.page.and.pencil"),
    "Confirmation":  StepsMetadata(title: "Confirmation", description: "All set?", icon: "text.badge.checkmark")
]
