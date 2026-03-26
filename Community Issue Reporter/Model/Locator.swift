//
//  Locator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import Foundation

struct Locator: Identifiable, Codable {
    let id: String?
    let country: String
    let region: String
    let city: String
}
