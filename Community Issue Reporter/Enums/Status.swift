//
//  Status.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import SwiftUI

enum IssueStatus: String, CaseIterable, Identifiable {
    case reported = "exclamationmark.bubble"
    case confirmed = "checkmark.square"
    case inProgress = "arrow.trianglehead.2.clockwise.rotate.90"
    case petitionToSign = "signature"
    case fixed = "wrench.and.screwdriver"
    
    var id: String { self.rawValue }
    
    var iconName: String { self.rawValue }
    
    var title: String {
        switch self {
            case .reported: return String(localized:"Reported")
            case .confirmed: return String(localized: "Confirmed")
            case .inProgress: return String(localized: "In Progress")
            case .petitionToSign: return String(localized: "Petition to Sign")
            case .fixed: return String(localized: "Fixed")
        }
    }
    
    var color: Color {
        switch self {
            case .reported: return .pink
            case .inProgress: return .orange
            case .fixed: return .blue
            case .petitionToSign: return .purple
            case .confirmed: return .green
        }
    }
    
    var identifier: Int {
        switch self {
        case .reported:
            return 1
        case .confirmed:
            return 2
        case .inProgress:
            return 3
        case .petitionToSign:
            return 4
        case .fixed:
            return 5
        }
    }
}
