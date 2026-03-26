//
//  BahamasCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let bahamas = Country(id: 2, name: "The Bahamas", regions: [
    Region(id: 1, name: "New Providence", cities: [
        City(id: 1, name: "Nassau"),
    ]),
    Region(id: 2, name: "Grand Bahama", cities: [
        City(id: 1, name: "Freeport"),
        City(id: 2, name: "West End"),
        City(id: 3, name: "High Rock"),
    ]),
    Region(id: 3, name: "Abaco", cities: [
        City(id: 1, name: "Marsh Harbour"),
        City(id: 2, name: "Cooper's Town"),
        City(id: 3, name: "Treasure Cay"),
    ]),
    Region(id: 4, name: "Andros", cities: [
        City(id: 1, name: "Andros Town"),
        City(id: 2, name: "Nicholls Town"),
        City(id: 3, name: "Congo Town"),
    ]),
    Region(id: 5, name: "Eleuthera", cities: [
        City(id: 1, name: "Governor's Harbour"),
        City(id: 2, name: "Rock Sound"),
        City(id: 3, name: "Dunmore Town"),
    ]),
    Region(id: 6, name: "Exuma", cities: [
        City(id: 1, name: "George Town"),
    ]),
    Region(id: 7, name: "Bimini", cities: [
        City(id: 1, name: "Alice Town"),
    ]),
])
