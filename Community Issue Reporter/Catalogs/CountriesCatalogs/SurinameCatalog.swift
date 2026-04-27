//
//  SurinameCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let suriname = Country(id: 10, name: "Suriname", regions: [
    Region(id: 1, name: "Paramaribo", cities: [
        City(id: 1, name: "Paramaribo", legalName: "", isCapital: false, coordinates: .init(lat: 5.86638, lng: -55.16682)),
    ]),
    Region(id: 2, name: "Wanica", cities: [
        City(id: 1, name: "Lelydorp", legalName: "", isCapital: false, coordinates: .init(lat: 5.7, lng: -55.23333)),
    ]),
    Region(id: 3, name: "Nickerie", cities: [
        City(id: 1, name: "Nieuw Nickerie", legalName: "", isCapital: false, coordinates: .init(lat: 5.92606, lng: -56.97297)),
    ]),
    Region(id: 4, name: "Coronie", cities: [
        City(id: 1, name: "Totness", legalName: "", isCapital: false, coordinates: .init(lat: 5.87618, lng: -56.32572)),
    ]),
    Region(id: 5, name: "Saramacca", cities: [
        City(id: 1, name: "Groningen", legalName: "", isCapital: false, coordinates: .init(lat: 5.8, lng: -55.46667)),
    ]),
    Region(id: 6, name: "Commewijne", cities: [
        City(id: 1, name: "Nieuw Amsterdam", legalName: "", isCapital: false, coordinates: .init(lat: 5.88573, lng: -55.08871)),
    ]),
    Region(id: 7, name: "Marowijne", cities: [
        City(id: 1, name: "Albina", legalName: "", isCapital: false, coordinates: .init(lat: 5.49788, lng: -54.05522)),
        City(id: 2, name: "Moengo", legalName: "", isCapital: false, coordinates: .init(lat: 5.61411, lng: -54.40121)),
    ]),
    Region(id: 8, name: "Para", cities: [
        City(id: 1, name: "Onverwacht", legalName: "", isCapital: false, coordinates: .init(lat: 5.58983, lng: -55.19462)),
    ]),
    Region(id: 9, name: "Brokopondo", cities: [
        City(id: 1, name: "Brokopondo", legalName: "", isCapital: false, coordinates: .init(lat: 5.05594, lng: -54.98043)),
    ]),
    Region(id: 10, name: "Sipaliwini", cities: [
        City(id: 1, name: "Kwamalasamutu", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
])
