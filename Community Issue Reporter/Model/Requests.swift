//
//  Requests.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import Foundation

struct OAuthSignInPayload: Encodable {
    let token: String
}

struct MapExplorerQueryParams: Encodable {
    
    var lat: Double
    var lng: Double
    var radius: Int
    var issueTypeIds: [Int]
    var severityIds: [Int]
    var statusIds: [Int]
}

struct PaginatedRequestQueryParams: Encodable {
    let page: Int?
    let limit: Int?
    var issueTypeId: Int?
    var severityId: Int?
    var countryCode: String?
    var departmentalCapital: Bool?
    var cityName: String?
    var stateName: String?
    var groupingName: String?
    var ordering: String

    init(
        page: Int? = 1,
        limit: Int? = 3,
        issueTypeId: Int? = nil,
        severityId: Int? = nil,
        countryCode: String? = nil,
        departmentalCapital: Bool? = nil,
        cityName: String? = nil,
        stateName: String? = nil,
        groupingName: String? = nil,
        ordering: OrderFilter = .descending
    ) {
        self.page = page
        self.limit = limit
        self.issueTypeId = issueTypeId
        self.severityId = severityId
        self.countryCode = countryCode
        self.departmentalCapital = departmentalCapital
        self.cityName = cityName
        self.stateName = stateName
        self.groupingName = groupingName
        self.ordering = ordering.filter
    }
}

struct LocatorHeaders {
    let headers: Array<HTTPHeader>
}
