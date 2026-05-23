//
//  FlatteningUtility.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/5/26.
//

import Foundation

extension Country {
    func flattenToFriendlyDistribution() -> FriendlyCityDistributionList {
        var flatCities: [FriendlyCityDistribution] = []
        
        for region in self.regions {
            for city in region.cities {
                let friendlyCity = FriendlyCityDistribution(
                    firstLevel: self.name,
                    secondLevel: region.name,
                    thirdLevel: city.name,
                    ZipCode: "",
                    legalGroupName: city.legalName,
                    coordinates: city.coordinates,
                    isDepartmentalCapital: city.isDepartmentalCapital,
                    groupingId: city.groupingId,
                    groupingName: city.groupingName
                )
                flatCities.append(friendlyCity)
            }
        }
        
        return FriendlyCityDistributionList(cities: flatCities)
    }
}
