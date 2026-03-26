//
//  DeepLinkHandler.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

func deepLinkHandler(_ url: URL) {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    let path = url.path
    
    guard let petitionId = components?.queryItems?.first(where: {
        $0.name == "id"
    })?.value else { return }
    
    print("path: \(path)")
    print("petition: \(petitionId)")
    
}
