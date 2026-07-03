//
//  Locator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

final class Locator: Identifiable, Codable {
    var id = UUID().uuidString
    var countryCode: String
    var firstLevel: String
    var secondLevel: String
    var thirdLevel: String
    var groupingId: String
    var cityId: String
    var groupingName: String
    var groupingNameCode: String
    var lat: Double
    var lng: Double
    var geoCode: String
    var zipCode: String
    var isCapitalCityRaw: Int
    var isDepartmentalCapitalRaw: Int
    var cityNameSortKey: String
    var address: String
    
    var isCapitalCity: Bool { isCapitalCityRaw == 1 }
    var isDepartmentalCapital: Bool { isDepartmentalCapitalRaw == 1 }
    
    init(
        countryCode: String = "",
        firstLevel: String = "",
        secondLevel: String = "",
        thirdLevel: String = "",
        groupingId: String = "",
        cityId: String = "",
        groupingName: String = "",
        groupingNameCode: String = "",
        lat: Double = 0,
        lng: Double = 0,
        geoCode: String = "",
        zipCode: String = "",
        isCapitalCityRaw: Int = 0,
        isDepartmentalCapitalRaw: Int = 0,
        cityNameSortKey: String = "",
        address: String = ""
    ) {
        self.countryCode = countryCode
        self.firstLevel = firstLevel
        self.secondLevel = secondLevel
        self.thirdLevel = thirdLevel
        self.groupingId = groupingId
        self.cityId = cityId
        self.groupingName = groupingName
        self.groupingNameCode = groupingNameCode
        self.lat = lat
        self.lng = lng
        self.geoCode = geoCode
        self.zipCode = zipCode
        self.isCapitalCityRaw = isCapitalCityRaw
        self.isDepartmentalCapitalRaw = isDepartmentalCapitalRaw
        self.cityNameSortKey = cityNameSortKey
        self.address = address
    }
    
    func setCountryCode(_ countryCode: CountryCode)  {
        self.countryCode = countryCode.rawValue
    }

}
