//
//  Share.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/6/26.
//

import Foundation

struct ReportToShare: Codable {
    let reportId: String
    let title: String
    let city: String
    let country: String
    let description: String
    let severity: String
    let issueType: String
    let status: String
    let coordinate: Coordinate
    let cellIndex: String
    let openCodeLocation: String
}

struct Share<T: Codable>: Codable {
    let payload: T
    let shareType: ShareType
    let lang: String
    
    init(_ payload: T, type shareType: ShareType, lang: String) {
        self.payload = payload
        self.shareType = shareType
        self.lang = lang
    }
}

struct ShareUrlResponse: Codable {
    let shareUrl: String
}
