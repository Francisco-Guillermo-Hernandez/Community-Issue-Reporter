//
//  ParaguayCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let paraguay = Country(id: 8, name: "Paraguay", regions: [
    Region(id: 1, name: "Distrito Capital", cities: [
        City(id: 1, name: "Asunción", legalName: "Asuncion", isCapital: false, coordinates: .init(lat: -25.28646, lng: -57.647)),
    ]),
    Region(id: 2, name: "Concepción", cities: [
        City(id: 1, name: "Concepción", legalName: "Concepcion", isCapital: false, coordinates: .init(lat: -23.39985, lng: -57.43236)),
        City(id: 2, name: "Horqueta", legalName: "", isCapital: false, coordinates: .init(lat: -23.34323, lng: -57.05212)),
    ]),
    Region(id: 3, name: "San Pedro", cities: [
        City(id: 1, name: "San Pedro del Ycuamandiyú", legalName: "San Pedro Del Ykuamandiyu", isCapital: false, coordinates: .init(lat: -24.08534, lng: -57.08745)),
        City(id: 2, name: "San Estanislao", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 4, name: "Cordillera", cities: [
        City(id: 1, name: "Caacupé", legalName: "Caacupe", isCapital: false, coordinates: .init(lat: -25.38575, lng: -57.14217)),
        City(id: 2, name: "Piribebuy", legalName: "", isCapital: false, coordinates: .init(lat: -25.46498, lng: -57.04183)),
    ]),
    Region(id: 5, name: "Guairá", cities: [
        City(id: 1, name: "Villarrica", legalName: "", isCapital: false, coordinates: .init(lat: -25.74946, lng: -56.43518)),
    ]),
    Region(id: 6, name: "Caaguazú", cities: [
        City(id: 1, name: "Coronel Oviedo", legalName: "", isCapital: false, coordinates: .init(lat: -25.44444, lng: -56.44028)),
        City(id: 2, name: "Caaguazú", legalName: "Caaguazu", isCapital: false, coordinates: .init(lat: -25.47104, lng: -56.01603)),
    ]),
    Region(id: 7, name: "Caazapá", cities: [
        City(id: 1, name: "Caazapá", legalName: "Caazapa", isCapital: false, coordinates: .init(lat: -26.19583, lng: -56.36806)),
    ]),
    Region(id: 8, name: "Itapúa", cities: [
        City(id: 1, name: "Encarnación", legalName: "Encarnacion", isCapital: false, coordinates: .init(lat: -27.33056, lng: -55.86667)),
        City(id: 2, name: "Cambyretá", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 9, name: "Misiones", cities: [
        City(id: 1, name: "San Juan Bautista", legalName: "", isCapital: false, coordinates: .init(lat: -26.66944, lng: -57.14583)),
        City(id: 2, name: "San Ignacio", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 10, name: "Paraguarí", cities: [
        City(id: 1, name: "Paraguarí", legalName: "Paraguari", isCapital: false, coordinates: .init(lat: -25.62083, lng: -57.14722)),
        City(id: 2, name: "Carapeguá", legalName: "Carapegua", isCapital: false, coordinates: .init(lat: -25.76344, lng: -57.24677)),
    ]),
    Region(id: 11, name: "Alto Paraná", cities: [
        City(id: 1, name: "Ciudad del Este", legalName: "Ciudad Del Este", isCapital: false, coordinates: .init(lat: -25.50972, lng: -54.61111)),
        City(id: 2, name: "Presidente Franco", legalName: "", isCapital: false, coordinates: .init(lat: -25.56384, lng: -54.61097)),
        City(id: 3, name: "Hernandarias", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Minga Guazú", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 12, name: "Central", cities: [
        City(id: 1, name: "Luque", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "San Lorenzo", legalName: "Carlos Antonio Lopez", isCapital: false, coordinates: .init(lat: -26.49324, lng: -54.79989)),
        City(id: 3, name: "Lambaré", legalName: "Lambare", isCapital: false, coordinates: .init(lat: -25.34682, lng: -57.60647)),
        City(id: 4, name: "Fernando de la Mora", legalName: "San Lorenzo", isCapital: false, coordinates: .init(lat: -25.3386, lng: -57.52167)),
        City(id: 5, name: "Capiatá", legalName: "Capiata", isCapital: false, coordinates: .init(lat: -25.3552, lng: -57.44545)),
        City(id: 6, name: "Limpio", legalName: "", isCapital: false, coordinates: .init(lat: -25.16611, lng: -57.48562)),
        City(id: 7, name: "Ñemby", legalName: "Ñemby", isCapital: false, coordinates: .init(lat: -25.3949, lng: -57.53574)),
        City(id: 8, name: "Mariano Roque Alonso", legalName: "", isCapital: false, coordinates: .init(lat: -25.20791, lng: -57.53202)),
    ]),
    Region(id: 13, name: "Ñeembucú", cities: [
        City(id: 1, name: "Pilar", legalName: "", isCapital: false, coordinates: .init(lat: -26.85874, lng: -58.30639)),
    ]),
    Region(id: 14, name: "Amambay", cities: [
        City(id: 1, name: "Pedro Juan Caballero", legalName: "", isCapital: false, coordinates: .init(lat: -22.54722, lng: -55.73333)),
    ]),
    Region(id: 15, name: "Canindeyú", cities: [
        City(id: 1, name: "Salto del Guairá", legalName: "Saltos Del Guaira", isCapital: false, coordinates: .init(lat: -24.0625, lng: -54.30694)),
        City(id: 2, name: "Curuguaty", legalName: "Curuguaty", isCapital: false, coordinates: .init(lat: -24.47184, lng: -55.69227)),
    ]),
    Region(id: 16, name: "Presidente Hayes", cities: [
        City(id: 1, name: "Villa Hayes", legalName: "", isCapital: false, coordinates: .init(lat: -25.09306, lng: -57.52361)),
    ]),
    Region(id: 17, name: "Boquerón", cities: [
        City(id: 1, name: "Filadelfia", legalName: "", isCapital: false, coordinates: .init(lat: -22.33936, lng: -60.03157)),
    ]),
    Region(id: 18, name: "Alto Paraguay", cities: [
        City(id: 1, name: "Fuerte Olimpo", legalName: "", isCapital: false, coordinates: .init(lat: -21.04153, lng: -57.87377)),
    ]),
])
