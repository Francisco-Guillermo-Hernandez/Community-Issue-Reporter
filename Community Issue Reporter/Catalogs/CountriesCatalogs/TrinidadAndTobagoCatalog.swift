//
//  TrinidadAndTobagoCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let trinidadAndTobago = Country(id: 13, name: "Trinidad and Tobago", regions: [
    Region(id: 1, name: "Port of Spain", cities: [
        City(id: 1, name: "Port of Spain", legalName: "", isCapital: false, coordinates: .init(lat: 10.66668, lng: -61.51889)),
    ]),
    Region(id: 2, name: "San Fernando", cities: [
        City(id: 1, name: "San Fernando", legalName: "", isCapital: false, coordinates: .init(lat: 10.27969, lng: -61.46835)),
    ]),
    Region(id: 3, name: "Chaguanas", cities: [
        City(id: 1, name: "Chaguanas", legalName: "", isCapital: false, coordinates: .init(lat: 10.51667, lng: -61.41667)),
    ]),
    Region(id: 4, name: "Arima", cities: [
        City(id: 1, name: "Arima", legalName: "", isCapital: false, coordinates: .init(lat: 10.63737, lng: -61.28228)),
    ]),
    Region(id: 5, name: "Tunapuna-Piarco", cities: [
        City(id: 1, name: "Tunapuna", legalName: "", isCapital: false, coordinates: .init(lat: 10.65245, lng: -61.38878)),
        City(id: 2, name: "Saint Joseph", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Piarco", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 6, name: "San Juan-Laventille", cities: [
        City(id: 1, name: "San Juan", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Barataria", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "Diego Martin", cities: [
        City(id: 1, name: "Diego Martin", legalName: "", isCapital: false, coordinates: .init(lat: 10.72081, lng: -61.56616)),
        City(id: 2, name: "Carenage", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 8, name: "Couva-Tabaquite-Talparo", cities: [
        City(id: 1, name: "Couva", legalName: "", isCapital: false, coordinates: .init(lat: 10.42248, lng: -61.46748)),
        City(id: 2, name: "Tabaquite", legalName: "", isCapital: false, coordinates: .init(lat: 10.38824, lng: -61.29704)),
    ]),
    Region(id: 9, name: "Point Fortin", cities: [
        City(id: 1, name: "Point Fortin", legalName: "", isCapital: false, coordinates: .init(lat: 10.17411, lng: -61.68407)),
    ]),
    Region(id: 10, name: "Tobago", cities: [
        City(id: 1, name: "Scarborough", legalName: "", isCapital: false, coordinates: .init(lat: 11.18229, lng: -60.73525)),
        City(id: 2, name: "Roxborough", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
])
