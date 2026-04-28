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
        do {
            
            let result = try await service.getReverseGeocodingResult(location: location)
            print("updateLocationDetails")
            
            
            var locator = LocatorDAO.shared.findBy(cityName: result?.cityName ?? "unk", country: result?.cityName ?? "unk")
                locator.address = result?.address ?? "unk"

                ReportDataModel.shared.updateLocator(with: locator)
                dump(result)
            
            
        } catch {
            
        }
        
    }
}
