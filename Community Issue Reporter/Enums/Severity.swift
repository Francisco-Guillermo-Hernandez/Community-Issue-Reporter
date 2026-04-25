//
//  Severity.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import SwiftUI

enum Severity: String, CaseIterable, Identifiable {
    case all = "asterisk.circle"
    case low = "dial.low"
    case medium = "dial.medium"
    case high = "dial.high"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .all:
            return String(localized:"All")
        case .low:
            return String(localized: "Low")
        case .medium:
             return String(localized: "Medium")
        case .high:
             return String(localized:"High")
        }
    }
    
    var color: Color {
        switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .blue
            case .all: return .primary
        }
    }
    
    var identifier: Int {
        switch self {
        case .all:
            return 0
        case .low:
            return 1
        case .medium:
            return 2
        case .high:
            return 3
        }
    }
    
    var iconName: String { self.rawValue }
}
