//
//  DominicanRepublicCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let dominicanRepublic = Country(id: 6, name: "Dominican Republic", regions: [
    Region(id: 1, name: "Distrito Nacional", cities: [
        City(id: 1, name: "Santo Domingo", legalName: "", isCapital: false, coordinates: .init(lat: 18.5, lng: -70)),
    ]),
    Region(id: 2, name: "Santo Domingo", cities: [
        City(id: 1, name: "Santo Domingo Este", legalName: "", isCapital: false, coordinates: .init(lat: 18.48361, lng: -69.84889)),
        City(id: 2, name: "Santo Domingo Oeste", legalName: "", isCapital: false, coordinates: .init(lat: 18.5, lng: -70)),
        City(id: 3, name: "Santo Domingo Norte", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Boca Chica", legalName: "", isCapital: false, coordinates: .init(lat: 18.45, lng: -69.6)),
    ]),
    Region(id: 3, name: "Santiago", cities: [
        City(id: 1, name: "Santiago de los Caballeros", legalName: "", isCapital: false, coordinates: .init(lat: 19.45083, lng: -70.69472)),
        City(id: 2, name: "Villa Bisonó", legalName: "Bisonó", isCapital: false, coordinates: .init(lat: 19.56378, lng: -70.87582)),
        City(id: 3, name: "Jánico", legalName: "", isCapital: false, coordinates: .init(lat: 19.08239, lng: -71.7054)),
    ]),
    Region(id: 4, name: "La Vega", cities: [
        City(id: 1, name: "Concepción de La Vega", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Constanza", legalName: "", isCapital: false, coordinates: .init(lat: 18.90919, lng: -70.74499)),
        City(id: 3, name: "Jarabacoa", legalName: "", isCapital: false, coordinates: .init(lat: 19.11683, lng: -70.63595)),
    ]),
    Region(id: 5, name: "Puerto Plata", cities: [
        City(id: 1, name: "San Felipe de Puerto Plata", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Sosúa", legalName: "", isCapital: false, coordinates: .init(lat: 19.7522, lng: -70.51995)),
        City(id: 3, name: "Cabarete", legalName: "Sosúa", isCapital: false, coordinates: .init(lat: 19.74982, lng: -70.40829)),
    ]),
    Region(id: 6, name: "La Altagracia", cities: [
        City(id: 1, name: "Salvaleón de Higüey", legalName: "Higüey", isCapital: false, coordinates: .init(lat: 18.61501, lng: -68.70798)),
        City(id: 2, name: "Punta Cana", legalName: "Higüey", isCapital: false, coordinates: .init(lat: 18.58182, lng: -68.40431)),
        City(id: 3, name: "Bávaro", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "San Cristóbal", cities: [
        City(id: 1, name: "San Cristóbal", legalName: "", isCapital: false, coordinates: .init(lat: 18.41694, lng: -70.10722)),
        City(id: 2, name: "Bajos de Haina", legalName: "", isCapital: false, coordinates: .init(lat: 18.41538, lng: -70.03317)),
    ]),
    Region(id: 8, name: "San Pedro de Macorís", cities: [
        City(id: 1, name: "San Pedro de Macorís", legalName: "", isCapital: false, coordinates: .init(lat: 18.4539, lng: -69.30864)),
    ]),
    Region(id: 9, name: "La Romana", cities: [
        City(id: 1, name: "La Romana", legalName: "", isCapital: false, coordinates: .init(lat: 18.42278, lng: -68.96639)),
    ]),
    Region(id: 10, name: "Duarte", cities: [
        City(id: 1, name: "San Francisco de Macorís", legalName: "", isCapital: false, coordinates: .init(lat: 19.29722, lng: -70.2575)),
    ]),
])
