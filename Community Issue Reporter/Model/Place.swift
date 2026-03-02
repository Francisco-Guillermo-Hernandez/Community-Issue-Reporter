//
//  Place.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/3/26.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    public var id: String
    public var title: String
    public var subtitle: String
    public var coordinate: CLLocationCoordinate2D
    public var mapItem: MKMapItem
    
    var address: String {
        if #available(iOS 26.0, *) {
            return mapItem.address?.fullAddress ?? ""
        } else {
            return mapItem.placemark.title ?? ""
        }
    }
    
    var phoneNumber: String? {
        return mapItem.phoneNumber
    }
}
