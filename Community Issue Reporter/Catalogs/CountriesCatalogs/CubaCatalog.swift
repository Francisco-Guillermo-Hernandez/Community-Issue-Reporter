//
//  CubaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let cuba = Country(id: 4, name: "Cuba", regions: [
    Region(id: 1, name: "La Habana", cities: [
        City(id: 1, name: "Havana"),
        City(id: 2, name: "Guanabacoa"),
        City(id: 3, name: "Marianao"),
    ]),
    Region(id: 2, name: "Santiago de Cuba", cities: [
        City(id: 1, name: "Santiago de Cuba"),
        City(id: 2, name: "Palma Soriano"),
        City(id: 3, name: "Contramaestre"),
    ]),
    Region(id: 3, name: "Camagüey", cities: [
        City(id: 1, name: "Camagüey"),
        City(id: 2, name: "Florida"),
        City(id: 3, name: "Nuevitas"),
    ]),
    Region(id: 4, name: "Holguín", cities: [
        City(id: 1, name: "Holguín"),
        City(id: 2, name: "Banes"),
        City(id: 3, name: "Moa"),
    ]),
    Region(id: 5, name: "Villa Clara", cities: [
        City(id: 1, name: "Santa Clara"),
        City(id: 2, name: "Sagua la Grande"),
        City(id: 3, name: "Placetas"),
    ]),
    Region(id: 6, name: "Guantánamo", cities: [
        City(id: 1, name: "Guantánamo"),
        City(id: 2, name: "Baracoa"),
    ]),
    Region(id: 7, name: "Matanzas", cities: [
        City(id: 1, name: "Matanzas"),
        City(id: 2, name: "Cárdenas"),
        City(id: 3, name: "Varadero"),
    ]),
    Region(id: 8, name: "Pinar del Río", cities: [
        City(id: 1, name: "Pinar del Río"),
        City(id: 2, name: "Consolación del Sur"),
    ]),
    Region(id: 9, name: "Cienfuegos", cities: [
        City(id: 1, name: "Cienfuegos"),
        City(id: 2, name: "Cruces"),
    ]),
    Region(id: 10, name: "Artemisa", cities: [
        City(id: 1, name: "Artemisa"),
        City(id: 2, name: "San Cristóbal"),
    ]),
])
