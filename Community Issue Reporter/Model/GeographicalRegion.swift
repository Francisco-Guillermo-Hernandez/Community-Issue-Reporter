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
    let isDepartmentalCapital: Bool?
    let metadata: [String: String]?
    let groupingId: String?
    let groupingName: String?
    
    init(
        id: Int,
        name: String,
        legalName: String,
        isCapital: Bool = false,
        coordinates: Coordinate,
        metadata: [String: String]? = nil,
        isDepartmentalCapital: Bool? = false,
        groupingId: String? = nil,
        groupingName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.legalName = legalName
        self.isCapital = isCapital
        self.coordinates = coordinates
        self.metadata = metadata
        self.isDepartmentalCapital = isDepartmentalCapital
        self.groupingId = groupingId
        self.groupingName = groupingName
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

struct FriendlyCityDistribution: Codable {
    let cityId: String
    let firstLevel: String
    let secondLevel: String
    let thirdLevel: String
    let ZipCode: String?
    let legalGroupName: String
    let coordinates: Coordinate
    let isCapitalCity: Int?
    let isDepartmentalCapital: Int?
    let groupingId: String?
    let groupingName: String?

    init(
        cityId: String,
        firstLevel: String,
        secondLevel: String,
        thirdLevel: String,
        ZipCode: String? = "",
        legalGroupName: String,
        coordinates: Coordinate,
        isCapitalCity: Int? = 0,
        isDepartmentalCapital: Int? = 0,
        groupingId: String? = nil,
        groupingName: String? = nil
    ) {
        self.cityId = cityId
        self.firstLevel = firstLevel
        self.secondLevel = secondLevel
        self.thirdLevel = thirdLevel
        self.ZipCode = ZipCode
        self.legalGroupName = legalGroupName
        self.coordinates = coordinates
        self.isCapitalCity = isCapitalCity
        self.isDepartmentalCapital = isDepartmentalCapital
        self.groupingId = groupingId
        self.groupingName = groupingName
    }
}


struct FriendlyCityDistributionList: Codable {
    let cities: [FriendlyCityDistribution]
}
