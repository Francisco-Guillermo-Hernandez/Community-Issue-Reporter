//
//  PetitionDefinitions.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/7/26.
//

import Foundation
import SwiftUI

enum PetitionStep: Int, CaseIterable, Comparable {
    case details = 1
    case reports = 2
    case signatures = 3
    case confirmation = 4
    
    static func < (lhs: PetitionStep, rhs: PetitionStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var metadataKey: String {
        switch self {
            case .details: return "Details"
            case .reports: return "Reports"
            case .signatures: return "Signatures"
            case .confirmation: return "Confirmation"
        }
    }
    
    var color: Color {
        switch self {
            case .details: return Color.theme.primary
            case .reports: return Color.theme.primary
            case .signatures: return Color.theme.primary
            case .confirmation: return Color.theme.secondary
        }
    }
}

let petitionStepsMetadata: [String: StepsMetadata] = [
    "Details": StepsMetadata(
        title: String(localized: "Details"),
        description: String(localized: ""),
        icon: "long.text.page.and.pencil"
    ),
    "Reports": StepsMetadata(
        title: String(localized: "Reports"),
        description: String(localized: "Choose related reports"),
        icon: "document.on.document"
    ),
    "Signatures": StepsMetadata(
        title: String(localized: "Signatures"),
        description: String(localized: "Set up your signature"),
        icon: "long.text.page.and.pencil"
    ),
    "Confirmation": StepsMetadata(
        title: String(localized: "Confirmation"),
        description: String(localized: "We received your petition. Thanks!"),
        icon: "text.badge.checkmark"
    ),
]
