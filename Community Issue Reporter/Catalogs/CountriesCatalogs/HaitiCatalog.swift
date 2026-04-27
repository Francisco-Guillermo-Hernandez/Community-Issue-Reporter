//
//  HaitiCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let haiti = Country(id: 8, name: "Haiti", regions: [
    Region(id: 1, name: "Ouest", cities: [
        City(id: 1, name: "Port-au-Prince", legalName: "Arrondissement de Port-au-Prince", coordinates: .init(lat: 18.54349, lng: -72.33881)),
        City(id: 2, name: "Carrefour", legalName: "Arrondissement de Port-au-Prince", coordinates: .init(lat: 18.54114, lng: -72.39922)),
        City(id: 3, name: "Delmas", legalName: "Arrondissement de Port-au-Prince", coordinates: .init(lat: 18.54478, lng: -72.30036)),
        City(id: 4, name: "Pétion-Ville", legalName: "Arrondissement de Port-au-Prince", coordinates: .init(lat: 18.5125, lng: -72.28528)),
    ]),
    Region(id: 2, name: "Nord", cities: [
        City(id: 1, name: "Cap-Haïtien", legalName: "Okap", coordinates: .init(lat: 19.75938, lng: -72.19815)),
        City(id: 2, name: "Limbé", legalName: "", coordinates: .init(lat: 19.70603, lng: -72.40336)),
    ]),
    Region(id: 3, name: "Artibonite", cities: [
        City(id: 1, name: "Gonaïves", legalName: "Gonayiv", coordinates: .init(lat: 19.44755, lng: -72.68928)),
        City(id: 2, name: "Saint-Marc", legalName: "Arrondissement de Saint-Marc", coordinates: .init(lat: 19.11136, lng: -72.70078)),
    ]),
    Region(id: 4, name: "Sud", cities: [
        City(id: 1, name: "Les Cayes", legalName: "Arrondissement des Cayes", coordinates: .init(lat: 18.19199, lng: -73.74948)),
        City(id: 2, name: "Port-Salut", legalName: "", coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 5, name: "Centre", cities: [
        City(id: 1, name: "Hinche", legalName: "Arrondissement de Hinche", coordinates: .init(lat: 19.15, lng: -72.01667)),
        City(id: 2, name: "Mirebalais", legalName: "Arrondissement de Mirebalais", coordinates: .init(lat: 18.83455, lng: -72.1048)),
    ]),
    Region(id: 6, name: "Sud-Est", cities: [
        City(id: 1, name: "Jacmel", legalName: "Arrondissement de Jacmel", coordinates: .init(lat: 18.23427, lng: -72.53539)),
    ]),
    Region(id: 7, name: "Nord-Ouest", cities: [
        City(id: 1, name: "Port-de-Paix", legalName: "Arrondissement de Port-de-Paix", coordinates: .init(lat: 19.93984, lng: -72.83037)),
    ]),
    Region(id: 8, name: "Nord-Est", cities: [
        City(id: 1, name: "Fort-Liberté", legalName: "Fòlibète", coordinates: .init(lat: 19.66273, lng: -71.83798)),
        City(id: 2, name: "Ouanaminthe", legalName: "Wanament", coordinates: .init(lat: 19.54934, lng: -71.72475)),
    ]),
    Region(id: 9, name: "Grand'Anse", cities: [
        City(id: 1, name: "Jérémie", legalName: "Jeremi", coordinates: .init(lat: 18.65, lng: -74.11667)),
    ]),
    Region(id: 10, name: "Nippes", cities: [
        City(id: 1, name: "Miragoâne", legalName: "Arrondissement de Miragoâne", coordinates: .init(lat: 18.44599, lng: -73.08957)),
    ]),
])
