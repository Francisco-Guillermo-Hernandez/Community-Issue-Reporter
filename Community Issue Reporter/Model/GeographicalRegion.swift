//
//  AdministrativeDivision.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import Foundation

struct City: Identifiable, Codable {
    let id: Int
    let name: String
}

struct Region: Identifiable, Codable {
    let id: Int
    let name: String
    let cities: [City]
}

struct Country: Identifiable, Codable {
    let id: Int
    let name: String
    let regions: [Region]
}

struct Contient: Identifiable, Codable {
    let id: Int
    let name: String
    let countries: [Country]
}
