//
//  IssueTypes.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import SwiftUI

enum IssueTypes: String, CaseIterable, Identifiable {
    case all = "asterisk.circle"
    case road = "road.lanes"
    case publicSpace = "tree"
    case building = "building"
    case other = "ellipsis"
    
    var id: String { self.rawValue }
    var title: String {
        switch self {
        case .all:
            return String(localized: "All")
        case .road:
            return String(localized: "Road")
        case .publicSpace:
            return String(localized: "Public Space")
        case .building:
            return String(localized: "Building")
        case .other:
            return String(localized: "Other")
        }
    }
    
    var identifier: Int {
        switch self {
        case .all:
            return 0
        case .road:
            return 1
        case .publicSpace:
            return 2
        case .building:
            return 3
        case .other:
            return 4
        }
    }
    
    var color: Color {
        switch self {
        case .road:
            return .red
        case .publicSpace:
            return .red
        case .building:
            return .red
        case .other:
            return .red
        default:
            return .primary
        }
    }

    var iconName: String { self.rawValue }
}
