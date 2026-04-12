//
//  Severity.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import Foundation

enum Severity: String, CaseIterable, Identifiable {
    case all = "asterisk.circle"
    case low = "dial.low"
    case medium = "dial.medium"
    case high = "dial.high"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
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
