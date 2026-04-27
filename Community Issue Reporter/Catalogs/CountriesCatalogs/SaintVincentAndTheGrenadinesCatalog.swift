//
//  SaintVincentAndTheGrenadinesCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let saintVincentAndTheGrenadines = Country(id: 12, name: "Saint Vincent and the Grenadines", regions: [
    Region(id: 1, name: "Saint George", cities: [
        City(id: 1, name: "Kingstown", legalName: "", coordinates: .init(lat: 13.15527, lng: -61.22742)),
        City(id: 2, name: "Arnos Vale", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Calliaqua", legalName: "", coordinates: .init(lat: 13.12867, lng: -61.19178)),
    ]),
    Region(id: 2, name: "Charlotte", cities: [
        City(id: 1, name: "Georgetown", legalName: "", coordinates: .init(lat: 13.28054, lng: -61.1185)),
        City(id: 2, name: "Byera Village", legalName: "", coordinates: .init(lat: 13.25636, lng: -61.11954)),
    ]),
    Region(id: 3, name: "Saint Andrew", cities: [
        City(id: 1, name: "Layou", legalName: "", coordinates: .init(lat: 13.20175, lng: -61.27014)),
    ]),
    Region(id: 4, name: "Saint Patrick", cities: [
        City(id: 1, name: "Barrouallie", legalName: "", coordinates: .init(lat: 13.23676, lng: -61.27275)),
    ]),
    Region(id: 5, name: "Saint David", cities: [
        City(id: 1, name: "Chateaubelair", legalName: "", coordinates: .init(lat: 13.29069, lng: -61.24043)),
    ]),
    Region(id: 6, name: "Grenadines", cities: [
        City(id: 1, name: "Port Elizabeth", legalName: "", coordinates: .init(lat: 13.01102, lng: -61.23548)),
        City(id: 2, name: "Ashton", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Hamilton", legalName: "", coordinates: .init(lat: 0, lng: 0)),
    ]),
])
