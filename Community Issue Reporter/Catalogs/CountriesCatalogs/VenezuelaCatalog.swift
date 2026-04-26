//
//  VenezuelaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let venezuela = Country(id: 12, name: "Venezuela", regions: [
    Region(id: 1, name: "Distrito Capital", cities: [
        City(id: 1, name: "Caracas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Zulia", cities: [
        City(id: 1, name: "Maracaibo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Cabimas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Ciudad Ojeda", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "San Francisco", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "Miranda", cities: [
        City(id: 1, name: "Los Teques", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Petare", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Guarenas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Guatire", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Baruta", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Ocumare del Tuy", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Carabobo", cities: [
        City(id: 1, name: "Valencia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Puerto Cabello", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Guacara", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Naguanagua", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Aragua", cities: [
        City(id: 1, name: "Maracay", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Turmero", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "La Victoria", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Cagua", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "Lara", cities: [
        City(id: 1, name: "Barquisimeto", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Carora", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Cabudare", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "El Tocuyo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Bolívar", cities: [
        City(id: 1, name: "Ciudad Guayana", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Ciudad Bolívar", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Upata", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Caicara del Orinoco", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 8, name: "Anzoátegui", cities: [
        City(id: 1, name: "Barcelona", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Puerto La Cruz", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "El Tigre", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Anaco", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 9, name: "Táchira", cities: [
        City(id: 1, name: "San Cristóbal", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Rubio", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "San Antonio del Táchira", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 10, name: "Monagas", cities: [
        City(id: 1, name: "Maturín", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 11, name: "Sucre", cities: [
        City(id: 1, name: "Cumaná", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Carúpano", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 12, name: "Portuguesa", cities: [
        City(id: 1, name: "Acarigua", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Guanare", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 13, name: "Falcón", cities: [
        City(id: 1, name: "Coro", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Punto Fijo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 14, name: "Mérida", cities: [
        City(id: 1, name: "Mérida", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "El Vigía", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 15, name: "Barinas", cities: [
        City(id: 1, name: "Barinas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 16, name: "Guárico", cities: [
        City(id: 1, name: "San Juan de los Morros", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Valle de la Pascua", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Calabozo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 17, name: "Trujillo", cities: [
        City(id: 1, name: "Valera", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Trujillo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 18, name: "Yaracuy", cities: [
        City(id: 1, name: "San Felipe", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 19, name: "Nueva Esparta", cities: [
        City(id: 1, name: "Porlamar", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "La Asunción", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 20, name: "Apure", cities: [
        City(id: 1, name: "San Fernando de Apure", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 21, name: "La Guaira", cities: [
        City(id: 1, name: "La Guaira", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Maiquetía", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 22, name: "Cojedes", cities: [
        City(id: 1, name: "San Carlos", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 23, name: "Delta Amacuro", cities: [
        City(id: 1, name: "Tucupita", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 24, name: "Amazonas", cities: [
        City(id: 1, name: "Puerto Ayacucho", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
