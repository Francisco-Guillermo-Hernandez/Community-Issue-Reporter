//
//  BuildShareURL.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/6/26.
//

import Foundation

enum ShareType: String {
    case report
    case petition
}

func buildShareURLWithComponents(for index: String, type: ShareType, slug: String) -> URL? {
    return shareBaseURL!.appending(component: index).appending(component: type.rawValue).appending(component: slug)
                
}

func buildShareURL(for path: String) -> URL? {
    return shareBaseURL!.appending(path: path)
}

func urlFromString(_ string: String) -> URL? {
    return URL(string: string)
}
