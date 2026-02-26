//
//  Severity.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import Foundation

enum Severity: String, CaseIterable, Identifiable {
    case low = "dial.low"
    case medium = "dial.medium"
    case high = "dial.high"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
    
    var iconName: String { self.rawValue }
}
