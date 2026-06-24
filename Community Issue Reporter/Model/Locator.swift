//
//  Locator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

struct Locator: Identifiable, Codable {
    var id = UUID().uuidString
    var countryCode: String
    var country: String
    var region: String
    var city: String
    var cityId: String
    var cityNameSortKey: String
    var cityCode: String
    var address: String

    init(
        countryCode: String,
        country: String,
        region: String,
        city: String,
        cityId: String,
        cityNameSortKey: String,
        cityCode: String,
        address: String
    ) {
        self.countryCode = countryCode
        self.country = country
        self.region = region
        self.city = city
        self.cityId = cityId
        self.cityNameSortKey = cityNameSortKey
        self.cityCode = cityCode
        self.address = address
    }
}
