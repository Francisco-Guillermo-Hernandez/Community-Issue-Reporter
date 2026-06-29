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


func buildPreviewAttachmentURL(_ reportContainer: String, _ fileName: String, _ state: ReportAttachmentState, _ updatedAtRaw: Int64? = nil) -> URL? {
    
    if state == .inappropriate || state == .deleted {
        return nil
    }
    
    var fragment: String = ""
    switch state {
        case .pending:
            fragment = "review"
        case .confirmed:
            fragment = "validated"
        default:
            break
    }
    
    let params: [URLQueryItem] = [
        URLQueryItem(name: "v", value: String(updatedAtRaw ?? 1))
    ]
    
    return Endpoints.baseURL
        .appending(component: "attachments")
        .appending(component: fragment)
        .appending(component: reportContainer)
        .appending(component: fileName)
        .appending(queryItems: params)
}

func urlFromString(_ string: String) -> URL? {
    return URL(string: string)
}
