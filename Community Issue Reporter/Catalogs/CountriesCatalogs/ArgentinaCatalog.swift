//
//  ArgentinaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let argentina = Country(id: 1, name: "Argentina", regions: [
    Region(id: 1, name: "Buenos Aires", cities: [
        City(id: 1, name: "La Plata", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Mar del Plata", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Bahía Blanca", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Lanús", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Quilmes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Tandil", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Pilar", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 8, name: "San Nicolás", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 9, name: "Pergamino", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 10, name: "Olavarría", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 2, name: "Córdoba", cities: [
        City(id: 1, name: "Córdoba", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Río Cuarto", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Villa María", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Villa Carlos Paz", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "San Francisco", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Alta Gracia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Río Tercero", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 3, name: "Santa Fe", cities: [
        City(id: 1, name: "Rosario", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Santa Fe", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Rafaela", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Venado Tuerto", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Reconquista", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Santo Tomé", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 7, name: "Villa Constitución", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 4, name: "Ciudad Autónoma de Buenos Aires", cities: [
        City(id: 1, name: "Buenos Aires", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 5, name: "Mendoza", cities: [
        City(id: 1, name: "Mendoza", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "San Rafael", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Godoy Cruz", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Guaymallén", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Las Heras", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 6, name: "Luján de Cuyo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 6, name: "Tucumán", cities: [
        City(id: 1, name: "San Miguel de Tucumán", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Yerba Buena", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Tafí Viejo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Concepción", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Alderetes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 7, name: "Entre Ríos", cities: [
        City(id: 1, name: "Paraná", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Concordia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Gualeguaychú", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Concepción del Uruguay", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Gualeguay", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 8, name: "Salta", cities: [
        City(id: 1, name: "Salta", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "San Ramón de la Nueva Orán", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Tartagal", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "General Güemes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Rosario de Lerma", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 9, name: "Chaco", cities: [
        City(id: 1, name: "Resistencia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Presidencia Roque Sáenz Peña", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Villa Ángela", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Charata", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Juan José Castelli", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 10, name: "Misiones", cities: [
        City(id: 1, name: "Posadas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Oberá", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Eldorado", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Puerto Iguazú", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Apóstoles", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 11, name: "Corrientes", cities: [
        City(id: 1, name: "Corrientes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Goya", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Paso de los Libres", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Curuzú Cuatiá", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 5, name: "Mercedes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 12, name: "Santiago del Estero", cities: [
        City(id: 1, name: "Santiago del Estero", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "La Banda", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Termas de Río Hondo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Frías", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 13, name: "San Juan", cities: [
        City(id: 1, name: "San Juan", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Rawson", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Chimbas", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Santa Lucía", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 14, name: "Jujuy", cities: [
        City(id: 1, name: "San Salvador de Jujuy", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "San Pedro", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Palpalá", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Perico", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 15, name: "Río Negro", cities: [
        City(id: 1, name: "Viedma", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "San Carlos de Bariloche", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "General Roca", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Cipolletti", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 16, name: "Neuquén", cities: [
        City(id: 1, name: "Neuquén", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Cutral Có", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Centenario", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Plottier", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 17, name: "Formosa", cities: [
        City(id: 1, name: "Formosa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Clorinda", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Pirané", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 18, name: "Chubut", cities: [
        City(id: 1, name: "Rawson", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Comodoro Rivadavia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Trelew", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 4, name: "Puerto Madryn", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 19, name: "San Luis", cities: [
        City(id: 1, name: "San Luis", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Villa Mercedes", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Merlo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 20, name: "Catamarca", cities: [
        City(id: 1, name: "San Fernando del Valle de Catamarca", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Valle Viejo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Recreo", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 21, name: "La Rioja", cities: [
        City(id: 1, name: "La Rioja", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Chilecito", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 22, name: "La Pampa", cities: [
        City(id: 1, name: "Santa Rosa", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "General Pico", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 23, name: "Santa Cruz", cities: [
        City(id: 1, name: "Río Gallegos", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Caleta Olivia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "El Calafate", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
    Region(id: 24, name: "Tierra del Fuego", cities: [
        City(id: 1, name: "Ushuaia", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 2, name: "Río Grande", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
        City(id: 3, name: "Tolhuin", legalName: "", isCapital: false, coordinates: .init(lat: 0.0, lng: 0.0)),
    ]),
])
