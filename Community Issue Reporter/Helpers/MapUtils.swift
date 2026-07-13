//
//  MapUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/7/26.
//

import Foundation
import CoreLocation

func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    return CLLocation(latitude: from.latitude, longitude: from.longitude).distance(from: CLLocation(latitude: to.latitude, longitude: to.latitude))
}

/// Distance between two coordinates
func distance(initial: Coordinate, final: Coordinate) -> CLLocationDistance {
    return initial.location.distance(from: final.location)
}
