//
//  Locator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

struct Locator: Identifiable, Codable {
    var id: String?
    var countryCode: String
    var country: String
    var region: String
    var city: String
    var address: String
    
    init(id: String? = nil, countryCode: String, country: String, region: String, city: String, address: String) {
        self.id = id
        self.countryCode = countryCode
        self.country = country
        self.region = region
        self.city = city
        self.address = address
    }
}
