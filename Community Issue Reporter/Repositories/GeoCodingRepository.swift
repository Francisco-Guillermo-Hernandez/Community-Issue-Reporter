//
//  GeoCodingRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import CoreLocation

final class GeoCodingRepository {
    
    static let shared = GeoCodingRepository()
    private let service: GeoCodingService
    private init() {
        self.service = .init()
    }
    
    func updateLocationDetails(from location: CLLocation) async  {
       
        
    }
}
