//
//  EcuadorCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let ecuador = Country(id: 6, name: "Ecuador", regions: [
    Region(id: 1, name: "Guayas", cities: [
        City(id: 1, name: "Guayaquil", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Durán", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Milagro", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Samborondón", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Daule", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Pichincha", cities: [
        City(id: 1, name: "Quito", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Sangolquí", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Machachi", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Cayambe", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "Manabí", cities: [
        City(id: 1, name: "Portoviejo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Manta", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Chone", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Montecristi", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Jipijapa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Azuay", cities: [
        City(id: 1, name: "Cuenca", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Gualaceo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Paute", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Los Ríos", cities: [
        City(id: 1, name: "Quevedo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Babahoyo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Ventanas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Buena Fe", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "El Oro", cities: [
        City(id: 1, name: "Machala", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Pasaje", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Santa Rosa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Huaquillas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Tungurahua", cities: [
        City(id: 1, name: "Ambato", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Baños de Agua Santa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Pelileo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 8, name: "Loja", cities: [
        City(id: 1, name: "Loja", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Catamayo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Cariamanga", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 9, name: "Chimborazo", cities: [
        City(id: 1, name: "Riobamba", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Guano", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 10, name: "Imbabura", cities: [
        City(id: 1, name: "Ibarra", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Otavalo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Cotacachi", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 11, name: "Santo Domingo de los Tsáchilas", cities: [
        City(id: 1, name: "Santo Domingo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 12, name: "Santa Elena", cities: [
        City(id: 1, name: "Santa Elena", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "La Libertad", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Salinas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 13, name: "Esmeraldas", cities: [
        City(id: 1, name: "Esmeraldas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Quinindé", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Atacames", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 14, name: "Cotopaxi", cities: [
        City(id: 1, name: "Latacunga", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Pujilí", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "La Maná", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 15, name: "Carchi", cities: [
        City(id: 1, name: "Tulcán", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 16, name: "Bolívar", cities: [
        City(id: 1, name: "Guaranda", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 17, name: "Cañar", cities: [
        City(id: 1, name: "Azogues", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "La Troncal", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 18, name: "Morona Santiago", cities: [
        City(id: 1, name: "Macas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 19, name: "Napo", cities: [
        City(id: 1, name: "Tena", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 20, name: "Pastaza", cities: [
        City(id: 1, name: "Puyo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 21, name: "Orellana", cities: [
        City(id: 1, name: "Puerto Francisco de Orellana", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 22, name: "Sucumbíos", cities: [
        City(id: 1, name: "Nueva Loja", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 23, name: "Zamora Chinchipe", cities: [
        City(id: 1, name: "Zamora", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 24, name: "Galápagos", cities: [
        City(id: 1, name: "Puerto Baquerizo Moreno", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Puerto Ayora", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
