//
//  District.swift
//  migration
//
//  Created by Francisco Hernandez on 2/7/26.
//

import Foundation
import SwiftData

@Model
final class District {
    @Attribute(.unique) var cityId: String
    var zipCode: String?
    var cityNameSortKey: String?
    var lat: Double
    var lng: Double
    var countryCode: String
    var firstLevel: String?
    var groupingId: String?
    var groupingName: String?
    var groupingNameSortKey: String?
    var groupingNameCode: String?
    var isCapitalCity: Bool
    var isDepartmentalCapital: Bool
    var legalGroupName: String?
    var secondLevel: String?
    var stateNameSortKey: String?
    var thirdLevel: String?
    var geoCode: String?
    
    @Relationship(deleteRule: .cascade, inverse: \Canton.district)
    var cantons: [Canton]? = []
    
    #Index<District>([\.geoCode], [\.zipCode], [\.groupingNameCode])
    
    init(
        cityId: String,
        zipCode: String? = nil,
        cityNameSortKey: String? = nil,
        lat: Double = 0.0,
        lng: Double = 0.0,
        countryCode: String,
        firstLevel: String? = nil,
        groupingId: String? = nil,
        groupingName: String? = nil,
        groupingNameSortKey: String? = nil,
        groupingNameCode: String? = nil,
        isCapitalCity: Bool = false,
        isDepartmentalCapital: Bool = false,
        legalGroupName: String? = nil,
        secondLevel: String? = nil,
        stateNameSortKey: String? = nil,
        thirdLevel: String? = nil,
        geoCode: String? = nil
    ) {
        self.cityId = cityId
        self.zipCode = zipCode
        self.cityNameSortKey = cityNameSortKey
        self.lat = lat
        self.lng = lng
        self.countryCode = countryCode
        self.firstLevel = firstLevel
        self.groupingId = groupingId
        self.groupingName = groupingName
        self.groupingNameSortKey = groupingNameSortKey
        self.groupingNameCode = groupingNameCode
        self.isCapitalCity = isCapitalCity
        self.isDepartmentalCapital = isDepartmentalCapital
        self.legalGroupName = legalGroupName
        self.secondLevel = secondLevel
        self.stateNameSortKey = stateNameSortKey
        self.thirdLevel = thirdLevel
        self.geoCode = geoCode
    }
}
