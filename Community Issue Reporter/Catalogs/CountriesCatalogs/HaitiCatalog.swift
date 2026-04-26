//
//  HaitiCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let haiti = Country(id: 8, name: "Haiti", regions: [
    Region(id: 1, name: "Ouest", cities: [
        City(id: 1, name: "Port-au-Prince", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Carrefour", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Delmas", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Pétion-Ville", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Nord", cities: [
        City(id: 1, name: "Cap-Haïtien", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Limbé", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "Artibonite", cities: [
        City(id: 1, name: "Gonaïves", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Saint-Marc", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Sud", cities: [
        City(id: 1, name: "Les Cayes", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Port-Salut", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Centre", cities: [
        City(id: 1, name: "Hinche", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Mirebalais", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "Sud-Est", cities: [
        City(id: 1, name: "Jacmel", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Nord-Ouest", cities: [
        City(id: 1, name: "Port-de-Paix", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 8, name: "Nord-Est", cities: [
        City(id: 1, name: "Fort-Liberté", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Ouanaminthe", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 9, name: "Grand'Anse", cities: [
        City(id: 1, name: "Jérémie", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 10, name: "Nippes", cities: [
        City(id: 1, name: "Miragoâne", legalName: "", coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
