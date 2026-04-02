//
//  IssueTypes.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import Foundation

enum IssueTypes: String, CaseIterable, Identifiable {
    case all = ""
    case road = "road.lanes"
    case publicSpace = "tree"
    case building = "building"
    case other = "ellipsis"
    
    var id: String { self.rawValue }
    var title: String {
        switch self {
        case .all:
            return "All"
        case .road:
            return "Road"
        case .publicSpace:
            return "Public Space"
        case .building:
            return "Building"
        case .other:
            return "Other"
        }
    }
    
    var identifier: Int {
        switch self {
        case .road:
            return 1
        case .publicSpace:
            return 2
        case .building:
            return 3
        case .other:
            return 4
        default:
            return 1
        }
    }

    var iconName: String { self.rawValue }
}
