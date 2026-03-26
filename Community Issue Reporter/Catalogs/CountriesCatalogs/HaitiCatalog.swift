//
//  HaitiCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let haiti = Country(id: 8, name: "Haiti", regions: [
    Region(id: 1, name: "Ouest", cities: [
        City(id: 1, name: "Port-au-Prince"),
        City(id: 2, name: "Carrefour"),
        City(id: 3, name: "Delmas"),
        City(id: 4, name: "Pétion-Ville"),
    ]),
    Region(id: 2, name: "Nord", cities: [
        City(id: 1, name: "Cap-Haïtien"),
        City(id: 2, name: "Limbé"),
    ]),
    Region(id: 3, name: "Artibonite", cities: [
        City(id: 1, name: "Gonaïves"),
        City(id: 2, name: "Saint-Marc"),
    ]),
    Region(id: 4, name: "Sud", cities: [
        City(id: 1, name: "Les Cayes"),
        City(id: 2, name: "Port-Salut"),
    ]),
    Region(id: 5, name: "Centre", cities: [
        City(id: 1, name: "Hinche"),
        City(id: 2, name: "Mirebalais"),
    ]),
    Region(id: 6, name: "Sud-Est", cities: [
        City(id: 1, name: "Jacmel"),
    ]),
    Region(id: 7, name: "Nord-Ouest", cities: [
        City(id: 1, name: "Port-de-Paix"),
    ]),
    Region(id: 8, name: "Nord-Est", cities: [
        City(id: 1, name: "Fort-Liberté"),
        City(id: 2, name: "Ouanaminthe"),
    ]),
    Region(id: 9, name: "Grand'Anse", cities: [
        City(id: 1, name: "Jérémie"),
    ]),
    Region(id: 10, name: "Nippes", cities: [
        City(id: 1, name: "Miragoâne"),
    ]),
])
