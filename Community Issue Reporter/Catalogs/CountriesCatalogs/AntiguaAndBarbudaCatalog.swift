//
//  AntiguaAndBarbudaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let antiguaAndBarbuda = Country(id: 1, name: "Antigua and Barbuda", regions: [
    Region(id: 1, name: "Saint George", cities: [
        City(id: 1, name: "Potters Village", legalName: "", isCapital: false, coordinates: .init(lat: 17.11337, lng: -61.81962)),
        City(id: 2, name: "Piggotts", legalName: "", isCapital: false, coordinates: .init(lat: 17.11667, lng: -61.8)),
        City(id: 3, name: "Swetes" , legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Saint John", cities: [
        City(id: 1, name: "Saint John's", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Cedar Grove", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 3, name: "Saint Mary", cities: [
        City(id: 1, name: "Bolands", legalName: "", isCapital: false, coordinates: .init(lat: 17.06565, lng: -61.87466)),
        City(id: 2, name: "Old Road", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 4, name: "Saint Paul", cities: [
        City(id: 1, name: "Liberta", legalName: "", isCapital: false, coordinates: .init(lat: 17.04141, lng: -61.79052)),
        City(id: 2, name: "English Harbour", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Falmouth", legalName: "", isCapital: false, coordinates: .init(lat: 17.02741, lng: -61.78136)),
    ]),
    Region(id: 5, name: "Saint Peter", cities: [
        City(id: 1, name: "Parham", legalName: "", isCapital: false, coordinates: .init(lat: 17.09682, lng: -61.77046)),
        City(id: 2, name: "Pares", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 6, name: "Saint Philip", cities: [
        City(id: 1, name: "Freetown", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Willikies", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "Barbuda", cities: [
        City(id: 1, name: "Codrington", legalName: "", isCapital: false, coordinates: .init(lat: 17.6394, lng: -61.82437)),
    ]),
])
