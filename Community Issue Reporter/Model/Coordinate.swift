//
//  Coordinate.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 28/3/26.
//

import Foundation
import CoreLocation

struct Coordinate: Codable, Equatable, Hashable {
    var lat: Double
    var lng: Double
    
    init(lat: Double = 0.0, lng: Double = 0.0) {
        self.lat = lat
        self.lng = lng
    }
    
    init(_ lat: Double = 0.0, _ lng: Double = 0.0) {
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Extension
extension Coordinate {
    var location: CLLocation {
        get {
            CLLocation(latitude: lat, longitude: lng)
        }
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
}
