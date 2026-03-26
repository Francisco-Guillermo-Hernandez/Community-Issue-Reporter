//
//  DominicanRepublicCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let dominicanRepublic = Country(id: 6, name: "Dominican Republic", regions: [
    Region(id: 1, name: "Distrito Nacional", cities: [
        City(id: 1, name: "Santo Domingo"),
    ]),
    Region(id: 2, name: "Santo Domingo", cities: [
        City(id: 1, name: "Santo Domingo Este"),
        City(id: 2, name: "Santo Domingo Oeste"),
        City(id: 3, name: "Santo Domingo Norte"),
        City(id: 4, name: "Boca Chica"),
    ]),
    Region(id: 3, name: "Santiago", cities: [
        City(id: 1, name: "Santiago de los Caballeros"),
        City(id: 2, name: "Villa Bisonó"),
        City(id: 3, name: "Jánico"),
    ]),
    Region(id: 4, name: "La Vega", cities: [
        City(id: 1, name: "Concepción de La Vega"),
        City(id: 2, name: "Constanza"),
        City(id: 3, name: "Jarabacoa"),
    ]),
    Region(id: 5, name: "Puerto Plata", cities: [
        City(id: 1, name: "San Felipe de Puerto Plata"),
        City(id: 2, name: "Sosúa"),
        City(id: 3, name: "Cabarete"),
    ]),
    Region(id: 6, name: "La Altagracia", cities: [
        City(id: 1, name: "Salvaleón de Higüey"),
        City(id: 2, name: "Punta Cana"),
        City(id: 3, name: "Bávaro"),
    ]),
    Region(id: 7, name: "San Cristóbal", cities: [
        City(id: 1, name: "San Cristóbal"),
        City(id: 2, name: "Bajos de Haina"),
    ]),
    Region(id: 8, name: "San Pedro de Macorís", cities: [
        City(id: 1, name: "San Pedro de Macorís"),
    ]),
    Region(id: 9, name: "La Romana", cities: [
        City(id: 1, name: "La Romana"),
    ]),
    Region(id: 10, name: "Duarte", cities: [
        City(id: 1, name: "San Francisco de Macorís"),
    ]),
])
