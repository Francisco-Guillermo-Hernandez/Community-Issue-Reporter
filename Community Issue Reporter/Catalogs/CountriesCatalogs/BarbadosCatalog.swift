//
//  BarbadosCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let barbados = Country(id: 3, name: "Barbados", regions: [
    Region(id: 1, name: "Saint Michael", cities: [
        City(id: 1, name: "Bridgetown", legalName: "", isCapital: false, coordinates: .init(lat: 13.10732, lng: -59.62021)),
    ]),
    Region(id: 2, name: "Christ Church", cities: [
        City(id: 1, name: "Oistins", legalName: "", isCapital: false, coordinates: .init(lat: 13.07067, lng: -59.54637)),
    ]),
    Region(id: 3, name: "Saint James", cities: [
        City(id: 1, name: "Holetown", legalName: "", isCapital: false, coordinates: .init(lat: 13.18672, lng: -59.63808)),
    ]),
    Region(id: 4, name: "Saint Peter", cities: [
        City(id: 1, name: "Speightstown", legalName: "", isCapital: false, coordinates: .init(lat: 13.25072, lng: -59.64396)),
    ]),
    Region(id: 5, name: "Saint Philip", cities: [
        City(id: 1, name: "Six Cross Roads", legalName: "", isCapital: false, coordinates: .init(lat: 13.11772, lng: -59.477)),
    ]),
    Region(id: 6, name: "Saint George", cities: [
        City(id: 1, name: "Bulkeley", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "Saint John", cities: [
        City(id: 1, name: "Four Roads", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 8, name: "Saint Joseph", cities: [
        City(id: 1, name: "Bathsheba", legalName: "", isCapital: false, coordinates: .init(lat: 13.21133, lng: -59.52596)),
    ]),
    Region(id: 9, name: "Saint Thomas", cities: [
        City(id: 1, name: "Welchman Hall", legalName: "", isCapital: false, coordinates: .init(lat: 13.18676, lng: -59.57663)),
    ]),
    Region(id: 10, name: "Saint Andrew", cities: [
        City(id: 1, name: "Greenland", legalName: "", isCapital: false, coordinates: .init(lat: 13.25808, lng: -59.57763)),
    ]),
    Region(id: 11, name: "Saint Lucy", cities: [
        City(id: 1, name: "Checker Hall", legalName: "", isCapital: false, coordinates: .init(lat: 13.28445, lng: -59.64223)),
    ]),
])
