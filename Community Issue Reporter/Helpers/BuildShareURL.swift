//
//  BuildShareURL.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/6/26.
//

import Foundation

enum ShareType: String, Codable, CaseIterable {
    case report
    case petition
}

func buildShareURLWithComponents(for index: String, type: ShareType, slug: String) -> URL? {
    return Endpoints.shareableURL.appending(component: index).appending(component: type.rawValue).appending(component: slug)
                
}

func buildShareURL(for path: String) -> URL? {
    return Endpoints.shareableURL.appending(path: path)
}

func urlFromString(_ string: String) -> URL? {
    return URL(string: string)
}
