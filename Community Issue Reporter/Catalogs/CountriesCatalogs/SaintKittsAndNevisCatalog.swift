//
//  SaintKittsAndNevisCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let saintKittsAndNevis = Country(id: 10, name: "Saint Kitts and Nevis", regions: [
    Region(id: 1, name: "Saint George Basseterre", cities: [
        City(id: 1, name: "Basseterre",  legalName: "", isCapital: false, coordinates: .init(lat: 17.2955, lng: -62.72499)),
    ]),
    Region(id: 2, name: "Saint Peter Basseterre", cities: [
        City(id: 1, name: "Monkey Hill",  legalName: "", isCapital: false, coordinates: .init(lat: 17.32327, lng: -62.72914)),
    ]),
    Region(id: 3, name: "Saint Paul Charlestown", cities: [
        City(id: 1, name: "Charlestown",  legalName: "", isCapital: false, coordinates: .init(lat: 17.13333, lng: -62.61667)),
    ]),
    Region(id: 4, name: "Saint Anne Sandy Point", cities: [
        City(id: 1, name: "Sandy Point Town",  legalName: "", isCapital: false, coordinates: .init(lat: 17.35908, lng: -62.84858)),
    ]),
    Region(id: 5, name: "Saint John Capisterre", cities: [
        City(id: 1, name: "Sadlers",  legalName: "", isCapital: false, coordinates: .init(lat: 17.40454, lng: -62.79296)),
        City(id: 2, name: "Dieppe Bay Town",  legalName: "", isCapital: false, coordinates: .init(lat: 17.41473, lng: -62.8139)),
    ]),
    Region(id: 6, name: "Saint Thomas Lowland", cities: [
        City(id: 1, name: "Cotton Ground",  legalName: "", isCapital: false, coordinates: .init(lat: 17.16667, lng: -62.61667)),
    ]),
    Region(id: 7, name: "Saint James Windward", cities: [
        City(id: 1, name: "Newcastle",  legalName: "", isCapital: false, coordinates: .init(lat: 17.2, lng: -62.58333)),
    ]),
    Region(id: 8, name: "Saint George Gingerland", cities: [
        City(id: 1, name: "Market Shop",  legalName: "", isCapital: false, coordinates: .init(lat: 17.13218, lng: -62.57267)),
    ]),
])
