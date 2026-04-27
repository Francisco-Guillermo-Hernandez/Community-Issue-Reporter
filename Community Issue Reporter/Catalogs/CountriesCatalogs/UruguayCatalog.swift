//
//  UruguayCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let uruguay = Country(id: 11, name: "Uruguay", regions: [
    Region(id: 1, name: "Montevideo", cities: [
        City(id: 1, name: "Montevideo", legalName: "Municipio B", isCapital: false, coordinates: .init(lat: -34.90328, lng: -56.18816)),
    ]),
    Region(id: 2, name: "Canelones", cities: [
        City(id: 1, name: "Canelones", legalName: "", isCapital: false, coordinates: .init(lat: -34.52278, lng: -56.27778)),
        City(id: 2, name: "Las Piedras", legalName: "", isCapital: false, coordinates: .init(lat: -34.7302, lng: -56.21915)),
        City(id: 3, name: "Ciudad de la Costa", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Pando", legalName: "", isCapital: false, coordinates: .init(lat: -34.71716, lng: -55.9584)),
    ]),
    Region(id: 3, name: "Maldonado", cities: [
        City(id: 1, name: "Maldonado", legalName: "", isCapital: false, coordinates: .init(lat: -34.9, lng: -54.95)),
        City(id: 2, name: "Punta del Este", legalName: "Punta Del Este", isCapital: false, coordinates: .init(lat: -34.94747, lng: -54.93382)),
        City(id: 3, name: "San Carlos", legalName: "", isCapital: false, coordinates: .init(lat: -34.79123, lng: -54.91824)),
    ]),
    Region(id: 4, name: "Salto", cities: [
        City(id: 1, name: "Salto", legalName: "", isCapital: false, coordinates: .init(lat: -31.38333, lng: -57.96667)),
    ]),
    Region(id: 5, name: "Colonia", cities: [
        City(id: 1, name: "Colonia del Sacramento", legalName: "", isCapital: false, coordinates: .init(lat: -34.46262, lng: -57.83976)),
        City(id: 2, name: "Carmelo", legalName: "", isCapital: false, coordinates: .init(lat: -34.00023, lng: -58.28402)),
    ]),
    Region(id: 6, name: "Paysandú", cities: [
        City(id: 1, name: "Paysandú", legalName: "", isCapital: false, coordinates: .init(lat: -32.3171, lng: -58.08072)),
    ]),
    Region(id: 7, name: "San José", cities: [
        City(id: 1, name: "San José de Mayo", legalName: "", isCapital: false, coordinates: .init(lat: -34.3375, lng: -56.71361)),
    ]),
    Region(id: 8, name: "Rivera", cities: [
        City(id: 1, name: "Rivera", legalName: "", isCapital: false, coordinates: .init(lat: -30.90534, lng: -55.55076)),
    ]),
    Region(id: 9, name: "Tacuarembó", cities: [
        City(id: 1, name: "Tacuarembó", legalName: "", isCapital: false, coordinates: .init(lat: -31.71694, lng: -55.98111)),
    ]),
    Region(id: 10, name: "Soriano", cities: [
        City(id: 1, name: "Mercedes", legalName: "", isCapital: false, coordinates: .init(lat: -33.2524, lng: -58.03047)),
    ]),
    Region(id: 11, name: "Cerro Largo", cities: [
        City(id: 1, name: "Melo", legalName: "", isCapital: false, coordinates: .init(lat: -34.00023, lng: -58.28402)),
    ]),
    Region(id: 12, name: "Artigas", cities: [
        City(id: 1, name: "Artigas", legalName: "", isCapital: false, coordinates: .init(lat: -30.4, lng: -56.46667)),
    ]),
    Region(id: 13, name: "Rocha", cities: [
        City(id: 1, name: "Rocha", legalName: "", isCapital: false, coordinates: .init(lat: -34.48333, lng: -54.33333)),
    ]),
    Region(id: 14, name: "Florida", cities: [
        City(id: 1, name: "Florida", legalName: "", isCapital: false, coordinates: .init(lat: -34.09556, lng: -56.21417)),
    ]),
    Region(id: 15, name: "Lavalleja", cities: [
        City(id: 1, name: "Minas", legalName: "", isCapital: false, coordinates: .init(lat: -34.37589, lng: -55.23771)),
    ]),
    Region(id: 16, name: "Durazno", cities: [
        City(id: 1, name: "Durazno", legalName: "", isCapital: false, coordinates: .init(lat: -33.38056, lng: -56.52361)),
    ]),
    Region(id: 17, name: "Treinta y Tres", cities: [
        City(id: 1, name: "Treinta y Tres", legalName: "", isCapital: false, coordinates: .init(lat: -33.23333, lng: -54.38333)),
    ]),
    Region(id: 18, name: "Río Negro", cities: [
        City(id: 1, name: "Fray Bentos", legalName: "", isCapital: false, coordinates: .init(lat: -33.11651, lng: -58.31067)),
    ]),
    Region(id: 19, name: "Flores", cities: [
        City(id: 1, name: "Trinidad", legalName: "", isCapital: false, coordinates: .init(lat: -33.5165, lng: -56.89957)),
    ]),
])
