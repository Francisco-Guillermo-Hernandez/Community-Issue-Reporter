//
//  DeepLinkHandler.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

func deepLinkHandler(_ url: URL) {

    let components = url.pathComponents.filter { $0 != "/" }

    // components[0] = "7BTheYpPwK1L" hash
    // components[1] = "report"
    // components[2] = "a-big-pothole-in-the-middle-of-the-street"

    guard components.count >= 3, components[1] == "report" else { return }

    let reportId = components[0]
    let slug = components[2]

    print(
        "Deep linked successfully to Report ID: \(reportId) with slug: \(slug)"
    )
}
