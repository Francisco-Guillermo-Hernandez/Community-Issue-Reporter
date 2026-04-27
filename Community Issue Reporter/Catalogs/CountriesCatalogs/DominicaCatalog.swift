//
//  DominicaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let dominica = Country(id: 5, name: "Dominica", regions: [
    Region(id: 1, name: "Saint George", cities: [
        City(id: 1, name: "Roseau", legalName: "", isCapital: false, coordinates: .init(lat: 15.30174, lng: -61.38808)),
        City(id: 2, name: "Laudat", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 2, name: "Saint John", cities: [
        City(id: 1, name: "Portsmouth", legalName: "", isCapital: false, coordinates: .init(lat: 15.58288, lng: -61.45592)),
        City(id: 2, name: "Glanvillia", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 3, name: "Saint Andrew", cities: [
        City(id: 1, name: "Marigot", legalName: "", isCapital: false, coordinates: .init(lat: 15.53743, lng: -61.282)),
        City(id: 2, name: "Wesley", legalName: "", isCapital: false, coordinates: .init(lat: 15.56667, lng: -61.31667)),
        City(id: 3, name: "Calibishie", legalName: "", isCapital: false, coordinates: .init(lat: 15.59297, lng: -61.34901)),
    ]),
    Region(id: 4, name: "Saint Patrick", cities: [
        City(id: 1, name: "Berekua", legalName: "", isCapital: false, coordinates: .init(lat: 15.23333, lng: -61.31667)),
        City(id: 2, name: "Grand Bay", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 5, name: "Saint Paul", cities: [
        City(id: 1, name: "Mahaut", legalName: "", isCapital: false, coordinates: .init(lat: 15.36357, lng: -61.39701)),
        City(id: 2, name: "Pont Cassé", legalName: "", isCapital: false, coordinates: .init(lat: 15.36667, lng: -61.35)),
    ]),
    Region(id: 6, name: "Saint David", cities: [
        City(id: 1, name: "Castle Bruce", legalName: "", isCapital: false, coordinates: .init(lat: 15.44397, lng: -61.25723)),
        City(id: 2, name: "Rosalie", legalName: "", isCapital: false, coordinates: .init(lat: 15.36667, lng: -61.26667)),
    ]),
    Region(id: 7, name: "Saint Joseph", cities: [
        City(id: 1, name: "Saint Joseph", legalName: "", isCapital: false, coordinates: .init(lat: 15.4061, lng: -61.42374)),
        City(id: 2, name: "Coulibistrie", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 8, name: "Saint Luke", cities: [
        City(id: 1, name: "Pointe Michel", legalName: "", isCapital: false, coordinates: .init(lat: 15.25976, lng: -61.37452)),
    ]),
    Region(id: 9, name: "Saint Mark", cities: [
        City(id: 1, name: "Soufrière", legalName: "", isCapital: false, coordinates: .init(lat: 15.23374, lng: -61.35881)),
    ]),
    Region(id: 10, name: "Saint Peter", cities: [
        City(id: 1, name: "Colihaut", legalName: "", isCapital: false, coordinates: .init(lat: 15.48478, lng: -61.46215)),
    ]),
])
