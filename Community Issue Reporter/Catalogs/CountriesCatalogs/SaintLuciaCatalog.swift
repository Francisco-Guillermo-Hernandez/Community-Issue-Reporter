//
//  SaintLuciaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let saintLucia = Country(id: 11, name: "Saint Lucia", regions: [
    Region(id: 1, name: "Castries", cities: [
        City(id: 1, name: "Castries", legalName: "Ciceron", isCapital: false, coordinates: .init(lat: 13.9957, lng: -61.00614)),
        City(id: 2, name: "Bisee", legalName: "Bissee", isCapital: false, coordinates: .init(lat: 14.02429, lng: -60.97445)),
        City(id: 3, name: "Ciceron", legalName: "Monkey Town Ciceron", isCapital: false, coordinates: .init(lat: 13.99009, lng: -61.00806)),
    ]),
    Region(id: 2, name: "Gros Islet", cities: [
        City(id: 1, name: "Gros Islet", legalName: "Rodney Heights", isCapital: false, coordinates: .init(lat: 14.06667, lng: -60.95)),
        City(id: 2, name: "Rodney Bay", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 3, name: "Vieux Fort", cities: [
        City(id: 1, name: "Vieux Fort", legalName: "Moule A Chique", isCapital: false, coordinates: .init(lat: 13.71667, lng: -60.95)),
    ]),
    Region(id: 4, name: "Soufrière", cities: [
        City(id: 1, name: "Soufrière", legalName: "Town", isCapital: false, coordinates: .init(lat: 13.85616, lng: -61.0566)),
    ]),
    Region(id: 5, name: "Dennery", cities: [
        City(id: 1, name: "Dennery", legalName: "Pascal", isCapital: false, coordinates: .init(lat: 13.91409, lng: -60.89132)),
    ]),
    Region(id: 6, name: "Micoud", cities: [
        City(id: 1, name: "Micoud", legalName: "Village", isCapital: false, coordinates: .init(lat: 13.81667, lng: -60.9)),
    ]),
    Region(id: 7, name: "Laborie", cities: [
        City(id: 1, name: "Laborie", legalName: "H'Erelle", isCapital: false, coordinates: .init(lat: 13.75, lng: -60.98333)),
    ]),
    Region(id: 8, name: "Anse la Raye", cities: [
        City(id: 1, name: "Anse la Raye", legalName: "Au Tabor", isCapital: false, coordinates: .init(lat: 13.94619, lng: -61.03879)),
    ]),
    Region(id: 9, name: "Choiseul", cities: [
        City(id: 1, name: "Choiseul", legalName: "La Fargue", isCapital: false, coordinates: .init(lat: 13.77273, lng: -61.04931)),
    ]),
    Region(id: 10, name: "Canaries", cities: [
        City(id: 1, name: "Canaries", legalName: "", isCapital: false, coordinates: .init(lat: 13.90224, lng: -61.06459)),
    ]),
])
