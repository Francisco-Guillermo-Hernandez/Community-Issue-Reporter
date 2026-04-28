//
//  OrderFilter.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/3/26.
//

import Foundation

enum OrderFilter: String, CaseIterable, Identifiable {
    case ascending
    case descending
    
    var title: String {
        switch self {
        case .ascending:
            return String(localized: "Oldest to Newest")
        case .descending:
            return String(localized: "Newest to Oldest")
        }
    }
    
    var filter: String {
        switch self {
        case .ascending:
            return "asc"
        case .descending:
            return "desc"
        }
    }
    
    var id: Self { self }
}
