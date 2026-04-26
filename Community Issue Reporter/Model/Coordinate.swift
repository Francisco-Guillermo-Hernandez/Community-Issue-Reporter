//
//  Coordinate.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import Foundation

struct Coordinate: Codable, Equatable {
    var lat: Double
    var lng: Double
    
    init(lat: Double = 0.0, lng: Double = 0.0) {
        self.lat = lat
        self.lng = lng
    }
}
