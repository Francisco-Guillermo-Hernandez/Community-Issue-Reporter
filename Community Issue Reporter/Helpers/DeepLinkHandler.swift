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

    guard components.count >= 3 else { return nil }
    
    let resourceHash = components[0]
    let resourceType = components[1]
    let slug = components[2]
    
    return DeepLink(of: resourceHash, with: slug, type: resourceType)
}

struct DeepLink {
    let resourceHash: String
    let slug: String
    let type: DeepLinkHandlerType
    
    init(of resourceHash: String, with slug: String, type: String) {
        self.resourceHash = resourceHash
        self.slug = slug
        
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
}

enum DeepLinkHandlerType {
    case report
    case petition
    case updateInfo
    case unknown
}
