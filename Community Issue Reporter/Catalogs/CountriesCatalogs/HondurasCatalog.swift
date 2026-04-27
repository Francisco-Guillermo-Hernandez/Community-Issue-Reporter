//
//  HondurasCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let honduras = Country(id: 3, name: "Honduras", regions: [
    Region(id: 1, name: "Francisco Morazán", cities: [
        City(id: 1, name: "Tegucigalpa", legalName: "Distrito Central", isCapital: true, coordinates: .init(lat: 14.0818, lng: -87.20681)),
        City(id: 2, name: "Santa Lucía", legalName: "Nueva Ocotepeque", coordinates: .init(lat: 14.41667, lng: -89.2)),
        City(id: 3, name: "Valle de Ángeles", legalName: "Comayagua", coordinates: .init(lat: 14.49921, lng: -87.63989)),
        City(id: 4, name: "Sabanagrande", legalName: "", coordinates: .init(lat: 13.80778, lng: -87.25917)),
        City(id: 5, name: "Talanga", legalName: "", coordinates: .init(lat: 14.4, lng: -87.08333)),
    ], hasTheCapital: true),
    Region(id: 2, name: "Cortés", cities: [
        City(id: 1, name: "San Pedro Sula", legalName: "", coordinates: .init(lat: 15.50417, lng: -88.025)),
        City(id: 2, name: "Choloma", legalName: "", coordinates: .init(lat: 15.61444, lng: -87.95302)),
        City(id: 3, name: "Puerto Cortés", legalName: "Puerto Cortés", coordinates: .init(lat: 15.82562, lng: -87.92968)),
        City(id: 4, name: "Villanueva", legalName: "", coordinates: .init(lat: 15.31476, lng: -87.99383)),
        City(id: 5, name: "La Lima", legalName: "", coordinates: .init(lat: 15.43333, lng: -87.91667)),
    ]),
    Region(id: 3, name: "Yoro", cities: [
        City(id: 1, name: "El Progreso", legalName: "", coordinates: .init(lat: 15.4, lng: -87.8)),
        City(id: 2, name: "Yoro", legalName: "", coordinates: .init(lat: 15.1375, lng: -87.12778)),
        City(id: 3, name: "Olanchito", legalName: "", coordinates: .init(lat: 15.48131, lng: -86.57415)),
        City(id: 4, name: "Santa Rita", legalName: "Santa Rita", coordinates: .init(lat: 14.86748, lng: -89.1)),
        City(id: 5, name: "Morazán", legalName: "", coordinates: .init(lat: 15.31667, lng: -87.6)),
    ]),
    Region(id: 4, name: "Olancho", cities: [
        City(id: 1, name: "Juticalpa", legalName: "", coordinates: .init(lat: 14.66667, lng: -86.21944)),
        City(id: 2, name: "Catacamas", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Campamento", legalName: "", coordinates: .init(lat: 14.55, lng: -86.65)),
        City(id: 4, name: "San Esteban", legalName: "", coordinates: .init(lat: 15.21231, lng: -85.76996)),
        City(id: 5, name: "Dulce Nombre de Culmí", legalName: "", coordinates: .init(lat: 15.1, lng: -85.53333)),
    ]),
    Region(id: 5, name: "Choluteca", cities: [
        City(id: 1, name: "Choluteca", legalName: "Choluteca", coordinates: .init(lat: 13.30028, lng: -87.19083)),
        City(id: 2, name: "San Marcos de Colón", legalName: "", coordinates: .init(lat: 13.43333, lng: -86.8)),
        City(id: 3, name: "Pespire", legalName: "", coordinates: .init(lat: 13.59222, lng: -87.36167)),
        City(id: 4, name: "El Triunfo", legalName: "", coordinates: .init(lat: 13.11667, lng: -87)),
        City(id: 5, name: "Namasigüe", legalName: "", coordinates: .init(lat: 13.20472, lng: -87.13889)),
    ]),
    Region(id: 6, name: "Comayagua", cities: [
        City(id: 1, name: "Comayagua", legalName: "", isCapital: true, coordinates: .init(lat: 14.73333, lng: -88.03333)),
        City(id: 2, name: "Siguatepeque", legalName: "", coordinates: .init(lat: 14.59691, lng: -87.83102)),
        City(id: 3, name: "Villa de San Antonio", legalName: "", coordinates: .init(lat: 14.32594, lng: -87.61351)),
        City(id: 4, name: "La Libertad", legalName: "Lepaera", coordinates: .init(lat: 14.81132, lng: -88.58715)),
        City(id: 5, name: "Taulabé", legalName: "", coordinates: .init(lat: 14.69251, lng: -87.96537)),
    ], hasTheCapital: true),
    Region(id: 7, name: "El Paraíso", cities: [
        City(id: 1, name: "Danlí", legalName: "", coordinates: .init(lat: 14.03333, lng: -86.58333)),
        City(id: 2, name: "El Paraíso", legalName: "", coordinates: .init(lat: 13.86667, lng: -86.55)),
        City(id: 3, name: "Teupasenti", legalName: "", coordinates: .init(lat: 14.21667, lng: -86.7)),
        City(id: 4, name: "Morocelí", legalName: "", coordinates: .init(lat: 14.11667, lng: -86.86667)),
        City(id: 5, name: "Yauyupe", legalName: "", coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 8, name: "Atlántida", cities: [
        City(id: 1, name: "La Ceiba", legalName: "", coordinates: .init(lat: 15.75971, lng: -86.78221)),
        City(id: 2, name: "Tela", legalName: "", coordinates: .init(lat: 15.77425, lng: -87.46731)),
        City(id: 3, name: "El Porvenir", legalName: "Siguatepeque", coordinates: .init(lat: 14.58775, lng: -87.89253)),
        City(id: 4, name: "La Masica", legalName: "", coordinates: .init(lat: 15.61667, lng: -87.11667)),
        City(id: 5, name: "Arizona", legalName: "", coordinates: .init(lat: 15.63333, lng: -87.31667)),
    ]),
    Region(id: 9, name: "Copán", cities: [
        City(id: 1, name: "Santa Rosa de Copán", legalName: "", coordinates: .init(lat: 14.76667, lng: -88.77917)),
        City(id: 2, name: "Copán Ruinas", legalName: "", coordinates: .init(lat: 14.83936, lng: -89.15583)),
        City(id: 3, name: "La Entrada", legalName: "Nueva Arcadia", coordinates: .init(lat: 15.06381, lng: -88.74627)),
        City(id: 4, name: "Cucuyagua", legalName: "", coordinates: .init(lat: 14.64777, lng: -88.87385)),
        City(id: 5, name: "Florida", legalName: "", coordinates: .init(lat: 15.02692, lng: -88.83567)),
    ]),
    Region(id: 10, name: "Colón", cities: [
        City(id: 1, name: "Tocoa", legalName: "", coordinates: .init(lat: 15.68333, lng: -86)),
        City(id: 2, name: "Trujillo", legalName: "", coordinates: .init(lat: 15.91667, lng: -85.95417)),
        City(id: 3, name: "Sonaguera", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Saba", legalName: "San Manuel", coordinates: .init(lat: 15.37351, lng: -87.93176)),
        City(id: 5, name: "Bonito Oriental", legalName: "", coordinates: .init(lat: 15.74765, lng: -85.73559)),
    ]),
])
