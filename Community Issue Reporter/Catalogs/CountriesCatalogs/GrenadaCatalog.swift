//
//  GrenadaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let grenada = Country(id: 7, name: "Grenada", regions: [
    Region(id: 1, name: "Saint George", cities: [
        City(id: 1, name: "St. George's", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Calliste", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Saint Andrew", cities: [
        City(id: 1, name: "Grenville", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "Saint David", cities: [
        City(id: 1, name: "St. David's", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Saint John", cities: [
        City(id: 1, name: "Gouyave", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Saint Mark", cities: [
        City(id: 1, name: "Victoria", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "Saint Patrick", cities: [
        City(id: 1, name: "Sauteurs", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Carriacou and Petite Martinique", cities: [
        City(id: 1, name: "Hillsborough", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
