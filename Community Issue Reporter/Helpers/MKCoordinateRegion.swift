//
//  MKCoordinateRegion.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {

    static var applePark: Self {
        Self(
            center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
            latitudinalMeters: 250000,
            longitudinalMeters: 250000
        )
    }
}
