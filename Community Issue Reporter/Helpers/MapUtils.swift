//
//  MapUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 11/7/26.
//

import Foundation
import CoreLocation
import MapKit

func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    return CLLocation(latitude: from.latitude, longitude: from.longitude).distance(from: CLLocation(latitude: to.latitude, longitude: to.latitude))
}

/// Distance between two coordinates
func distance(initial: Coordinate, final: Coordinate) -> CLLocationDistance {
    return initial.location.distance(from: final.location)
}

func openInAppleMaps(_ location: CLLocationCoordinate2D, title: String) {
    let label = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    let urlString = "https://maps.apple.com/?ll=\(location.latitude),\(location.longitude)?zoom=14&q=\(label)"
    
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}


func openOnGoogleMaps(_ location: CLLocationCoordinate2D, title: String) {
    let customLabel = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "comgooglemaps://?q=\(location.latitude),\(location.longitude)(\(customLabel))&z=14"
    if let url = URL(string: urlString),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
