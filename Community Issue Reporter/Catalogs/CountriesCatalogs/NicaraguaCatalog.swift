//
//  NicaraguaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let nicaragua = Country(id: 4, name: "Nicaragua", regions: [
    Region(id: 1, name: "Managua", cities: [
        City(id: 1, name: "Managua",legalName: "", isCapital: true, coordinates: .init(lat: 12.13282, lng: -86.2504)),
        City(id: 2, name: "Tipitapa",legalName: "Municipio de Tipitapa", isCapital: false, coordinates: .init(lat: 12.19732, lng: -86.09706)),
        City(id: 3, name: "Ciudad Sandino",legalName: "", isCapital: false, coordinates: .init(lat: 12.15889, lng: -86.34417)),
        City(id: 4, name: "Mateare",legalName: "", isCapital: false, coordinates: .init(lat: 12.23512, lng: -86.42809)),
        City(id: 5, name: "San Rafael del Sur",legalName: "", isCapital: false, coordinates: .init(lat: 11.84854, lng: -86.43839)),
    ], hasTheCapital: true),
    Region(id: 2, name: "Matagalpa", cities: [
        City(id: 1, name: "Matagalpa",legalName: "", isCapital: false, coordinates: .init(lat: 12.92559, lng: -85.91747)),
        City(id: 2, name: "Sébaco",legalName: "", isCapital: false, coordinates: .init(lat: 12.85321, lng: -86.0963)),
        City(id: 3, name: "San Isidro",legalName: "", isCapital: false, coordinates: .init(lat: 12.92957, lng: -86.19521)),
        City(id: 4, name: "Dario",legalName: "", isCapital: false, coordinates: .init(lat: 12.73143, lng: -86.12402)),
        City(id: 5, name: "Muy Muy",legalName: "Municipio de Muy Muy", isCapital: false, coordinates: .init(lat: 12.76224, lng: -85.62915)),
    ]),
    Region(id: 3, name: "Jinotega", cities: [
        City(id: 1, name: "Jinotega",legalName: "", isCapital: false, coordinates: .init(lat: 13.09103, lng: -86.00234)),
        City(id: 2, name: "San Rafael del Norte",legalName: "Municipio de San Rafael del Norte", isCapital: false, coordinates: .init(lat: 13.21248, lng: -86.11089)),
        City(id: 3, name: "La Concordia",legalName: "Municipio de La Concordia", isCapital: false, coordinates: .init(lat: 13.19528, lng: -86.16659)),
        City(id: 4, name: "San Sebastián de Yalí",legalName: "Municipio de San Sebastián de Yalí", isCapital: false, coordinates: .init(lat: 13.3054, lng: -86.18641)),
        City(id: 5, name: "Wiwilí de Jinotega",legalName: "", isCapital: false, coordinates: .init(lat: 13.61494, lng: -85.81676)),
    ]),
    Region(id: 4, name: "Chinandega", cities: [
        City(id: 1, name: "Chinandega",legalName: "", isCapital: false, coordinates: .init(lat: 12.62937, lng: -87.13105)),
        City(id: 2, name: "El Viejo",legalName: "", isCapital: false, coordinates: .init(lat: 12.66348, lng: -87.16663)),
        City(id: 3, name: "Corinto",legalName: "", isCapital: false, coordinates: .init(lat: 12.4825, lng: -87.17304)),
        City(id: 4, name: "Chichigalpa",legalName: "", isCapital: false, coordinates: .init(lat: 12.57758, lng: -87.02705)),
        City(id: 5, name: "Somotillo",legalName: "", isCapital: false, coordinates: .init(lat: 13.04387, lng: -86.90506)),
    ]),
    Region(id: 5, name: "León", cities: [
        City(id: 1, name: "León",legalName: "", isCapital: false, coordinates: .init(lat: 12.43787, lng: -86.87804)),
        City(id: 2, name: "La Paz Centro",legalName: "", isCapital: false, coordinates: .init(lat: 12.34, lng: -86.67528)),
        City(id: 3, name: "Nagarote",legalName: "", isCapital: false, coordinates: .init(lat: 12.26593, lng: -86.56474)),
        City(id: 4, name: "Telica",legalName: "", isCapital: false, coordinates: .init(lat: 12.522, lng: -86.85938)),
        City(id: 5, name: "Quezalguaque",legalName: "Municipio de Quezalguaque", isCapital: false, coordinates: .init(lat: 12.50683, lng: -86.90292)),
    ]),
    Region(id: 6, name: "Masaya", cities: [
        City(id: 1, name: "Masaya",legalName: "", isCapital: false, coordinates: .init(lat: 11.97444, lng: -86.09417)),
        City(id: 2, name: "Nindirí",legalName: "", isCapital: false, coordinates: .init(lat: 12.00386, lng: -86.12128)),
        City(id: 3, name: "La Concepción",legalName: "", isCapital: false, coordinates: .init(lat: 11.93711, lng: -86.18976)),
        City(id: 4, name: "Masatepe",legalName: "", isCapital: false, coordinates: .init(lat: 11.91445, lng: -86.14458)),
        City(id: 5, name: "Nandasmo",legalName: "", isCapital: false, coordinates: .init(lat: 11.92411, lng: -86.12072)),
    ]),
    Region(id: 7, name: "Granada", cities: [
        City(id: 1, name: "Granada",legalName: "", isCapital: false, coordinates: .init(lat: 11.92988, lng: -85.95602)),
        City(id: 2, name: "Diriomo",legalName: "", isCapital: false, coordinates: .init(lat: 11.87631, lng: -86.05184)),
        City(id: 3, name: "Nandaime",legalName: "Municipio de Nandaime", isCapital: false, coordinates: .init(lat: 11.75696, lng: -86.05286)),
        City(id: 4, name: "Diriá",legalName: "", isCapital: false, coordinates: .init(lat: 11.85812, lng: -86.23922)),
    ]),
    Region(id: 8, name: "Estelí", cities: [
        City(id: 1, name: "Estelí",legalName: "", isCapital: false, coordinates: .init(lat: 13.09185, lng: -86.35384)),
        City(id: 2, name: "Condega",legalName: "", isCapital: false, coordinates: .init(lat: 13.36502, lng: -86.39846)),
        City(id: 3, name: "Pueblo Nuevo",legalName: "", isCapital: false, coordinates: .init(lat: 13.37984, lng: -86.48075)),
        City(id: 4, name: "La Trinidad",legalName: "", isCapital: false, coordinates: .init(lat: 12.96881, lng: -86.23534)),
    ]),
    Region(id: 9, name: "Chontales", cities: [
        City(id: 1, name: "Juigalpa",legalName: "", isCapital: false, coordinates: .init(lat: 12.10629, lng: -85.36452)),
        City(id: 2, name: "Acoyapa",legalName: "", isCapital: false, coordinates: .init(lat: 11.97028, lng: -85.17113)),
        City(id: 3, name: "Santo Tomás",legalName: "", isCapital: false, coordinates: .init(lat: 12.06938, lng: -85.09059)),
        City(id: 4, name: "Villa Sandino",legalName: "", isCapital: false, coordinates: .init(lat: 12.0483, lng: -84.99362)),
    ]),
    Region(id: 10, name: "Rivas", cities: [
        City(id: 1, name: "Rivas",legalName: "", isCapital: false, coordinates: .init(lat: 11.43716, lng: -85.82632)),
        City(id: 2, name: "San Juan del Sur",legalName: "", isCapital: false, coordinates: .init(lat: 11.25292, lng: -85.87049)),
        City(id: 3, name: "Tola",legalName: "", isCapital: false, coordinates: .init(lat: 11.43927, lng: -85.93891)),
        City(id: 4, name: "Moyogalpa",legalName: "Municipio de Moyogalpa", isCapital: false, coordinates: .init(lat: 11.54006, lng: -85.69795)),
    ]),
])
