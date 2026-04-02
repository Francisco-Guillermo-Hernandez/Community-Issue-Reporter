//
//  Categories.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/2/26.
//

import Foundation

enum Categories: String, CaseIterable, Codable {
    case all
    case prevention
    case corrective
    case replacement
    case construction
    case installation
    case inspection
    case emergency
    
    var id: String { return rawValue }
    
    var title : String {
        switch self {
            case .all: return "All"
            case .prevention: return "Prevention"
            case .corrective: return "Corrective"
            case .replacement: return "Replacement"
            case .construction: return "Construction"
            case .installation: return "Installation"
            case .inspection: return "Inspection"
            case .emergency: return "Emergency"
        }
    }
    
    var minimunAmountOfSignatures: Int {
        switch self {
            case .all: return 100
            case .prevention: return 10
            case .corrective: return 10
            case .replacement: return 20
            case .construction: return 50
            case .installation: return 40
            case .inspection: return 20
            case .emergency: return 5
        }
    }

}
