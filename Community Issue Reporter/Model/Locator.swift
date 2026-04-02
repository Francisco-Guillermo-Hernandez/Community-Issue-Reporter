//
//  Locator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

struct Locator: Identifiable, Codable {
    let id: String?
    let countryCode: String
    let country: String
    let region: String
    let city: String
    
    init(id: String? = nil, countryCode: String, country: String, region: String, city: String) {
        self.id = id
        self.countryCode = countryCode
        self.country = country
        self.region = region
        self.city = city
    }
}
