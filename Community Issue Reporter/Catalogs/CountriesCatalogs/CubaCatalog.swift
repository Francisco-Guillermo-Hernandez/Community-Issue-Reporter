//
//  CubaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let cuba = Country(id: 4, name: "Cuba", regions: [
    Region(id: 1, name: "La Habana", cities: [
        City(id: 1, name: "Havana", legalName: "", isCapital: false, coordinates: .init(lat: 23.13302, lng: -82.38304)),
        City(id: 2, name: "Guanabacoa", legalName: "Municipio de Regla", isCapital: false, coordinates: .init(lat: 23.12518, lng: -82.30067)),
        City(id: 3, name: "Marianao", legalName: "Playa", isCapital: false, coordinates: .init(lat: 23.07385, lng: -82.4189)),
    ]),
    Region(id: 2, name: "Santiago de Cuba", cities: [
        City(id: 1, name: "Santiago de Cuba", legalName: "Municipio de Santiago de Cuba", isCapital: false, coordinates: .init(lat: 20.02083, lng: -75.82667)),
        City(id: 2, name: "Palma Soriano", legalName: "Municipio de Palma Soriano", isCapital: false, coordinates: .init(lat: 20.2113, lng: -75.99362)),
        City(id: 3, name: "Contramaestre", legalName: "", isCapital: false, coordinates: .init(lat: 20.29879, lng: -76.24511)),
    ]),
    Region(id: 3, name: "Camagüey", cities: [
        City(id: 1, name: "Camagüey", legalName: "Municipio de Camagüey", isCapital: false, coordinates: .init(lat: 21.38083, lng: -77.91694)),
        City(id: 2, name: "Florida", legalName: "Municipio de Florida", isCapital: false, coordinates: .init(lat: 21.52536, lng: -78.22579)),
        City(id: 3, name: "Nuevitas", legalName: "Municipio de Nuevitas", isCapital: false, coordinates: .init(lat: 21.54585, lng: -77.26504)),
    ]),
    Region(id: 4, name: "Holguín", cities: [
        City(id: 1, name: "Holguín", legalName: "Municipio de Holguín", isCapital: false, coordinates: .init(lat: 20.88722, lng: -76.26306)),
        City(id: 2, name: "Banes", legalName: "Municipio de Banes", isCapital: false, coordinates: .init(lat: 20.96116, lng: -75.722)),
        City(id: 3, name: "Moa", legalName: "", isCapital: false, coordinates: .init(lat: 20.65776, lng: -74.95075)),
    ]),
    Region(id: 5, name: "Villa Clara", cities: [
        City(id: 1, name: "Santa Clara", legalName: "Municipio de Santa Clara", isCapital: false, coordinates: .init(lat: 22.40694, lng: -79.96472)),
        City(id: 2, name: "Sagua la Grande", legalName: "Municipio de Sagua la Grande", isCapital: false, coordinates: .init(lat: 22.80667, lng: -80.07556)),
        City(id: 3, name: "Placetas", legalName: "Remedios", isCapital: false, coordinates: .init(lat: 22.31184, lng: -79.6544)),
    ]),
    Region(id: 6, name: "Guantánamo", cities: [
        City(id: 1, name: "Guantánamo", legalName: "Municipio de Guantánamo", isCapital: false, coordinates: .init(lat: 20.14444, lng: -75.20917)),
        City(id: 2, name: "Baracoa", legalName: "Municipio de Caimito", isCapital: false, coordinates: .init(lat: 23.04601, lng: -82.56723)),
    ]),
    Region(id: 7, name: "Matanzas", cities: [
        City(id: 1, name: "Matanzas", legalName: "Municipio de Matanzas", isCapital: false, coordinates: .init(lat: 23.04111, lng: -81.5775)),
        City(id: 2, name: "Cárdenas", legalName: "Municipio de Cárdenas", isCapital: false, coordinates: .init(lat: 23.03661, lng: -81.20596)),
        City(id: 3, name: "Varadero", legalName: "Municipio de Cárdenas", isCapital: false, coordinates: .init(lat: 23.15678, lng: -81.24441)),
    ]),
    Region(id: 8, name: "Pinar del Río", cities: [
        City(id: 1, name: "Pinar del Río", legalName: "Municipio de Pinar del Río", isCapital: false, coordinates: .init(lat: 22.41667, lng: -83.69667)),
        City(id: 2, name: "Consolación del Sur", legalName: "Municipio de Consolación del Sur", isCapital: false, coordinates: .init(lat: 22.50419, lng: -83.51442)),
    ]),
    Region(id: 9, name: "Cienfuegos", cities: [
        City(id: 1, name: "Cienfuegos", legalName: "La Habana Vieja", isCapital: false, coordinates: .init(lat: 23.16076, lng: -82.32798)),
        City(id: 2, name: "Cruces", legalName: "Municipio de Santa Isabel de las Lajas", isCapital: false, coordinates: .init(lat: 22.34203, lng: -80.27021)),
    ]),
    Region(id: 10, name: "Artemisa", cities: [
        City(id: 1, name: "Artemisa", legalName: "Municipio de Artemisa", isCapital: false, coordinates: .init(lat: 22.81667, lng: -82.75944)),
        City(id: 2, name: "San Cristóbal", legalName: "Municipio de San Cristóbal", isCapital: false, coordinates: .init(lat: 22.71658, lng: -83.05647)),
    ]),
])
