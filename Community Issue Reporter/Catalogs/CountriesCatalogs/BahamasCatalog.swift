//
//  BahamasCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let bahamas = Country(id: 2, name: "The Bahamas", regions: [
    Region(id: 1, name: "New Providence", cities: [
        City(id: 1, name: "Nassau", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 2, name: "Grand Bahama", cities: [
        City(id: 1, name: "Freeport", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 2, name: "West End", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 3, name: "High Rock", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 3, name: "Abaco", cities: [
        City(id: 1, name: "Marsh Harbour", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 2, name: "Cooper's Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 3, name: "Treasure Cay", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 4, name: "Andros", cities: [
        City(id: 1, name: "Andros Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 2, name: "Nicholls Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 3, name: "Congo Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 5, name: "Eleuthera", cities: [
        City(id: 1, name: "Governor's Harbour", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 2, name: "Rock Sound", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
        City(id: 3, name: "Dunmore Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 6, name: "Exuma", cities: [
        City(id: 1, name: "George Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
    Region(id: 7, name: "Bimini", cities: [
        City(id: 1, name: "Alice Town", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0) ),
    ]),
])
