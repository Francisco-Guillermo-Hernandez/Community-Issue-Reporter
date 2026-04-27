//
//  GeographicalRegion.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import Foundation

struct City: Identifiable, Codable {
    let id: Int
    let name: String
    let legalName: String
    let isCapital: Bool
    let coordinates: Coordinate
    let metadata: [String: String]?
    
    init(id: Int, name: String, legalName: String, isCapital: Bool = false, coordinates: Coordinate, metadata: [String: String]? = nil) {
        self.id = id
        self.name = name
        self.legalName = legalName
        self.isCapital = isCapital
        self.coordinates = coordinates
        self.metadata = metadata
    }
}

struct Region: Identifiable, Codable {
    let id: Int
    let name: String
    let cities: [City]
    let hasTheCapital: Bool?
    
    init(id: Int, name: String, cities: [City], hasTheCapital: Bool? = false) {
        self.id = id
        self.name = name
        self.cities = cities
        self.hasTheCapital = hasTheCapital
    }
}

struct Country: Identifiable, Codable {
    let id: Int
    let name: String
    let legalName: String?
    let regions: [Region]
    
    init(id: Int, name: String, legalName: String? = nil, regions: [Region]) {
        self.id = id
        self.name = name
        self.legalName = legalName
        self.regions = []
    }
}

struct GeographicalRegion: Identifiable, Codable {
    let id: Int
    let name: String
    let countries: [Country]
}
