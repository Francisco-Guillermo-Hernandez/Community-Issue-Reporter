//
//  OrderFilter.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/3/26.
//

import Foundation

enum OrderFilter: String, CaseIterable, Identifiable {
    case ascending = "Ascending"
    case descending = "Descending"
    
    var id: Self { self }
}
