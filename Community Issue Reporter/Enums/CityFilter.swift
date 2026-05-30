//
//  CityFilter.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/5/26.
//

import Foundation

enum CityFilter: String, CaseIterable, Equatable {
    
    case city
    case legal
    case state
    
    var id: String {
        self.rawValue
    }
    
    var text: String {
        switch self {
        case .legal:
            return String(localized: "Legal District")
        case .city:
            return String(localized: "City")
        case .state:
            return String(localized: "State")
        }
    }
}
