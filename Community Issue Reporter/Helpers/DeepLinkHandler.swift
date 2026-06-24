//
//  DeepLinkHandler.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

func deepLinkHandler(_ url: URL) -> DeepLink? {

    let components = url.pathComponents.filter { $0 != "/" }

    // components[0] = "7BTheYpPwK1L" hash
    // components[1] = "report"
    // components[2] = "a-big-pothole-in-the-middle-of-the-street"
    
    print(components)

    guard components.count >= 3 else { return nil }
    
    let resourceHash = components[0]
    let resourceType = components[1]
    let date = components[2]
    let cityCode = components[3]
    let countryCode = components[4]
    let slug = components[5]
    
    return DeepLink(
        of: resourceHash,
        with: slug,
        type: resourceType,
        at: date,
        in: cityCode,
        on: countryCode
    )
}

struct DeepLink {
    let resourceHash: String
    let slug: String
    let type: DeepLinkHandlerType
    let countryCode: String
    let cityCode: String
    let date: String
    
    init(of resourceHash: String, with slug: String, type: String, at date: String, in cityCode: String, on countryCode: String) {
        self.resourceHash = resourceHash
        self.slug = slug
        self.date = date
        self.cityCode = cityCode
        self.countryCode = countryCode
        
        switch type {
        case "report":
            self.type = .report
        case "petition":
            self.type = .petition
        case "update-info":
            self.type = .updateInfo
        default:
            self.type = .unknown
        }
    }
    
    var reportId: String {
        "\(countryCode)-\(cityCode)-\(date)-\(resourceHash)"
    }
}

enum DeepLinkHandlerType {
    case report
    case petition
    case updateInfo
    case unknown
}
