//
//  GeoCodingService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import MapKit

struct ReverseGeocodingResult {
    var country: String
    var cityName: String
    var address: String
}


struct GeoCodingService {
    
    
    func getReverseGeocodingResult( location: CLLocation) async throws -> ReverseGeocodingResult? {
        
        try? await Task.sleep(for: .milliseconds(500))
        if let request = MKReverseGeocodingRequest(location: location)  {
            let mapItems = try? await request.mapItems
            if let mapItem = mapItems?.first {
                let country = mapItem.addressRepresentations?.region?.identifier
                        ?? mapItem.addressRepresentations?.regionName
                        ?? "Unknown"
                let cityName = mapItem.addressRepresentations?.cityName ?? "Unknown"
                let address = mapItem.address?.fullAddress ??  mapItem.address?.shortAddress ?? "Unknown"
                
                return .init(country: country, cityName: cityName, address: address)
            }
        }
        
        return nil
    }
}
