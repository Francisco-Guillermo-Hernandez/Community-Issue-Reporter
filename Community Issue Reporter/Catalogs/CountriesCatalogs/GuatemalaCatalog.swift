//
//  GuatemalaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let guatemala = Country(id: 1, name: "Guatemala", regions: [
    Region(id: 1, name: "Guatemala", cities: [
        City(id: 1, name: "Guatemala City", legalName: "Municipio de Guatemala", isCapital: true, coordinates: .init(lat: 14.64072, lng: -90.51327)),
        City(id: 2, name: "Mixco", legalName: "Municipio de Mixco", isCapital: false, coordinates: .init(lat: 14.63077, lng: -90.60711)),
        City(id: 3, name: "Villa Nueva", legalName: "Municipio de Villa Nueva", isCapital: false, coordinates: .init(lat: 14.52512, lng: -90.58544)),
        City(id: 4, name: "Santa Catarina Pinula", legalName: "Municipio de Santa Catarina Pinula", isCapital: false, coordinates: .init(lat: 14.57047, lng: -90.49925)),
        City(id: 5, name: "San Miguel Petapa", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 6, name: "Amatitlán", legalName: "Municipio de Amatitlán", isCapital: false, coordinates: .init(lat: 14.4774, lng: -90.63489)),
        City(id: 7, name: "Villa Canales", legalName: "Municipio de Villa Canales", isCapital: false, coordinates: .init(lat: 14.48285, lng: -90.53425)),
    ], hasTheCapital: true),
    Region(id: 2, name: "Huehuetenango", cities: [
        City(id: 1, name: "Huehuetenango", legalName: "Municipio de Huehuetenango", isCapital: false, coordinates: .init(lat: 15.31918, lng: -91.47241)),
        City(id: 2, name: "Chiantla", legalName: "Municipio de Chiantla", isCapital: false, coordinates: .init(lat: 15.35484, lng: -91.45807)),
        City(id: 3, name: "San Pedro Soloma", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Jacaltenango", legalName: "Municipio de Jacaltenango", isCapital: false, coordinates: .init(lat: 15.66662, lng: -91.71177)),
        City(id: 5, name: "La Democracia", legalName: "Municipio de La Democracia", isCapital: false, coordinates: .init(lat: 14.22919, lng: -90.94806)),
    ]),
    Region(id: 3, name: "Alta Verapaz", cities: [
        City(id: 1, name: "Cobán", legalName: "Municipio de Cobán", isCapital: false, coordinates: .init(lat: 15.47083, lng: -90.37083)),
        City(id: 2, name: "San Pedro Carchá", legalName: "Municipio de San Pedro Carchá", isCapital: false, coordinates: .init(lat: 15.47745, lng: -90.31105)),
        City(id: 3, name: "Tactic", legalName: "Municipio de Tactic", isCapital: false, coordinates: .init(lat: 15.32218, lng: -90.35448)),
        City(id: 4, name: "Senahú", legalName: "Municipio de Senahú", isCapital: false, coordinates: .init(lat: 15.4164, lng: -89.82215)),
        City(id: 5, name: "Chisec", legalName: "Municipio de Chisec", isCapital: false, coordinates: .init(lat: 15.81311, lng: -90.28896)),
    ]),
    Region(id: 4, name: "San Marcos", cities: [
        City(id: 1, name: "San Marcos", legalName: "", isCapital: false, coordinates: .init(lat: 14.72504, lng: -91.25844)),
        City(id: 2, name: "San Pedro Sacatepéquez", legalName: "Municipio de San Pedro Sacatepéquez", isCapital: false, coordinates: .init(lat: 14.68612, lng: -90.64253)),
        City(id: 3, name: "Malacatán", legalName: "", isCapital: false, coordinates: .init(lat: 14.91132, lng: -92.05788)),
        City(id: 4, name: "Ayutla", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Catarina", legalName: "", isCapital: false, coordinates: .init(lat: 14.55135, lng: -90.78598)),
    ]),
    Region(id: 5, name: "Quiché", cities: [
        City(id: 1, name: "Santa Cruz del Quiché", legalName: "", isCapital: false, coordinates: .init(lat: 15.03085, lng: -91.14871)),
        City(id: 2, name: "Chichicastenango", legalName: "", isCapital: false, coordinates: .init(lat: 14.94333, lng: -91.11116)),
        City(id: 3, name: "Joyabaj", legalName: "", isCapital: false, coordinates: .init(lat: 14.99311, lng: -90.80161)),
        City(id: 4, name: "Nebaj", legalName: "", isCapital: false, coordinates: .init(lat: 15.40614, lng: -91.14682)),
        City(id: 5, name: "Ixcán", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 6, name: "Quetzaltenango", cities: [
        City(id: 1, name: "Quetzaltenango", legalName: "", isCapital: false, coordinates: .init(lat: 14.83472, lng: -91.51806)),
        City(id: 2, name: "Coatepeque", legalName: "", isCapital: false, coordinates: .init(lat: 14.70413, lng: -91.86426)),
        City(id: 3, name: "Salcajá", legalName: "", isCapital: false, coordinates: .init(lat: 14.87964, lng: -91.45699)),
        City(id: 4, name: "Esperanza", legalName: "Municipio de La Esperanza", isCapital: false, coordinates: .init(lat: 14.87169, lng: -91.5614)),
        City(id: 5, name: "Olintepeque", legalName: "", isCapital: false, coordinates: .init(lat: 14.88605, lng: -91.51472)),
    ]),
    Region(id: 7, name: "Escuintla", cities: [
        City(id: 1, name: "Escuintla", legalName: "Municipio de Mataquescuintla", isCapital: false, coordinates: .init(lat: 14.52917, lng: -90.18417)),
        City(id: 2, name: "Santa Lucía Cotzumalguapa", legalName: "Municipio de Santa Lucía Cotzumalguapa", isCapital: false, coordinates: .init(lat: 14.33505, lng: -91.02339)),
        City(id: 3, name: "Tiquisate", legalName: "Município de Tiquisate", isCapital: false, coordinates: .init(lat: 14.28356, lng: -91.36063)),
        City(id: 4, name: "Puerto San José", legalName: "Municipio de San José", isCapital: false, coordinates: .init(lat: 13.92216, lng: -90.81906)),
        City(id: 5, name: "Palín", legalName: "Municipio de Palín", isCapital: false, coordinates: .init(lat: 14.40358, lng: -90.69659)),
    ]),
    Region(id: 8, name: "Suchitepéquez", cities: [
        City(id: 1, name: "Mazatenango", legalName: "", isCapital: false, coordinates: .init(lat: 14.53417, lng: -91.50333)),
        City(id: 2, name: "Cuyotenango", legalName: "Municipio de Cuyotenango", isCapital: false, coordinates: .init(lat: 14.54006, lng: -91.57179)),
        City(id: 3, name: "Patulul", legalName: "", isCapital: false, coordinates: .init(lat: 14.42321, lng: -91.16049)),
        City(id: 4, name: "Chicacao", legalName: "", isCapital: false, coordinates: .init(lat: 14.54295, lng: -91.32636)),
        City(id: 5, name: "San Antonio Suchitepéquez", legalName: "Municipio de San Antonio Suchitepéquez", isCapital: false, coordinates: .init(lat: 14.53938, lng: -91.41442)),
    ]),
    Region(id: 9, name: "Totonicapán", cities: [
        City(id: 1, name: "Totonicapán", legalName: "Municipio de Totonicapán", isCapital: false, coordinates: .init(lat: 14.91167, lng: -91.36111)),
        City(id: 2, name: "Momostenango", legalName: "Municipio de Momostenango", isCapital: false, coordinates: .init(lat: 15.04437, lng: -91.40864)),
        City(id: 3, name: "San Francisco El Alto", legalName: "", isCapital: false, coordinates: .init(lat: 14.9449, lng: -91.4431)),
        City(id: 4, name: "Santa María Chiquimula", legalName: "Municipio de Santa María Chiquimula", isCapital: false, coordinates: .init(lat: 15.02992, lng: -91.3292)),
        City(id: 5, name: "San Cristóbal Totonicapán", legalName: "", isCapital: false, coordinates: .init(lat: 14.91682, lng: -91.4406)),
    ]),
    Region(id: 10, name: "Chimaltenango", cities: [
        City(id: 1, name: "Chimaltenango", legalName: "Municipio de Chimaltenango", isCapital: false, coordinates: .init(lat: 14.66111, lng: -90.81944)),
        City(id: 2, name: "El Tejar", legalName: "Municipio de El Tejar", isCapital: false, coordinates: .init(lat: 14.64683, lng: -90.79122)),
        City(id: 3, name: "Patzún", legalName: "Municipio de Patzún", isCapital: false, coordinates: .init(lat: 14.68189, lng: -91.01397)),
        City(id: 4, name: "Tecpán Guatemala", legalName: "Municipio de Tecpán Guatemala", isCapital: false, coordinates: .init(lat: 14.76181, lng: -90.99247)),
        City(id: 5, name: "Patzicía", legalName: "Municipio de Patzicía", isCapital: false, coordinates: .init(lat: 14.63194, lng: -90.92659)),
    ]),
])
