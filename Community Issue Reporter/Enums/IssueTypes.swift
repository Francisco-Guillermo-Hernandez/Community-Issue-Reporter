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

    var iconName: String { self.rawValue }
}
