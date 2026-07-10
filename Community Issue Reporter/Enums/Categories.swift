//
//  Categories.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/2/26.
//

import Foundation

enum Categories: String, CaseIterable, Codable, Equatable {
    case all
    case prevention
    case corrective
    case repair
    case replacement
    case construction
    case installation
    case inspection
    case emergency
    
    var id: String { self.rawValue }
    
    var title : String {
        switch self {
            case .all: return String(localized: "All")
            case .prevention: return String(localized: "Prevention")
            case .corrective: return String(localized: "Corrective")
            case .repair: return String(localized: "Repair")
            case .replacement: return String(localized: "Replacement")
            case .construction: return String(localized: "Construction")
            case .installation: return String(localized: "Installation")
            case .inspection: return String(localized: "Inspection")
            case .emergency: return String(localized: "Emergency")
        }
    }
    
    var minimunAmountOfSignatures: Int {
        switch self {
            case .all: return 100
            case .prevention: return 10
            case .corrective: return 10
            case .repair: return 20
            case .replacement: return 20
            case .construction: return 50
            case .installation: return 40
            case .inspection: return 20
            case .emergency: return 5
        }
    }
    
    var identifier: Int {
        switch self {
            case .prevention: return 1
            case .corrective: return 2
            case .repair: return 3
            case .replacement: return 4
            case .construction: return 5
            case .installation: return 6
            case .inspection: return 7
            case .emergency: return 8
        default:
            return 1
        }
    }

}

func getCategoryName(id: Int) -> String {
    return Categories.allCases.first(where: { $0.identifier == id })?.title
    ?? "Unknown"
}
