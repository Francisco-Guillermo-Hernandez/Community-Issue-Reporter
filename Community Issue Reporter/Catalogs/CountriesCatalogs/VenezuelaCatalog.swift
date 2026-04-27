//
//  VenezuelaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let venezuela = Country(id: 12, name: "Venezuela", regions: [
    Region(id: 1, name: "Distrito Capital", cities: [
        City(id: 1, name: "Caracas", legalName: "Municipio Libertador", isCapital: false, coordinates: .init(lat: 10.48801, lng: -66.87919)),
    ]),
    Region(id: 2, name: "Zulia", cities: [
        City(id: 1, name: "Maracaibo", legalName: "Municipio Maracaibo", isCapital: false, coordinates: .init(lat: 10.66663, lng: -71.61245)),
        City(id: 2, name: "Cabimas", legalName: "Municipio Cabimas", isCapital: false, coordinates: .init(lat: 10.39907, lng: -71.45206)),
        City(id: 3, name: "Ciudad Ojeda", legalName: "Municipio Lagunillas", isCapital: false, coordinates: .init(lat: 10.20161, lng: -71.3148)),
        City(id: 4, name: "San Francisco", legalName: "Municipio Simón Bolívar", isCapital: false, coordinates: .init(lat: 10.17793, lng: -66.74649)),
    ]),
    Region(id: 3, name: "Miranda", cities: [
        City(id: 1, name: "Los Teques", legalName: "Municipio Guaicaipuro", isCapital: false, coordinates: .init(lat: 10.34447, lng: -67.04325)),
        City(id: 2, name: "Petare", legalName: "Municipio Sucre", isCapital: false, coordinates: .init(lat: 10.47679, lng: -66.80786)),
        City(id: 3, name: "Guarenas", legalName: "Municipio Plaza", isCapital: false, coordinates: .init(lat: 10.47027, lng: -66.61934)),
        City(id: 4, name: "Guatire", legalName: "Municipio Zamora", isCapital: false, coordinates: .init(lat: 10.474, lng: -66.54241)),
        City(id: 5, name: "Baruta", legalName: "Municipio Baruta", isCapital: false, coordinates: .init(lat: 10.43424, lng: -66.87558)),
        City(id: 6, name: "Ocumare del Tuy", legalName: "Municipio Lander", isCapital: false, coordinates: .init(lat: 10.1182, lng: -66.77513)),
    ]),
    Region(id: 4, name: "Carabobo", cities: [
        City(id: 1, name: "Valencia", legalName: "Municipio Valencia", isCapital: false, coordinates: .init(lat: 10.16202, lng: -68.00765)),
        City(id: 2, name: "Puerto Cabello", legalName: "Municipio Puerto Cabello", isCapital: false, coordinates: .init(lat: 10.47306, lng: -68.0125)),
        City(id: 3, name: "Guacara", legalName: "Municipio Guacara", isCapital: false, coordinates: .init(lat: 10.22609, lng: -67.877)),
        City(id: 4, name: "Naguanagua", legalName: "Municipio Naguanagua", isCapital: false, coordinates: .init(lat: 10.25604, lng: -68.01649)),
    ]),
    Region(id: 5, name: "Aragua", cities: [
        City(id: 1, name: "Maracay", legalName: "Municipio Girardot", isCapital: false, coordinates: .init(lat: 10.23535, lng: -67.59113)),
        City(id: 2, name: "Turmero", legalName: "Municipio Santiago Mariño", isCapital: false, coordinates: .init(lat: 10.22856, lng: -67.47421)),
        City(id: 3, name: "La Victoria", legalName: "Municipio José Félix Ribas", isCapital: false, coordinates: .init(lat: 10.22677, lng: -67.33122)),
        City(id: 4, name: "Cagua", legalName: "Municipio Aricagua", isCapital: false, coordinates: .init(lat: 8.22432, lng: -71.13721)),
    ]),
    Region(id: 6, name: "Lara", cities: [
        City(id: 1, name: "Barquisimeto", legalName: "Municipio Iribarren", isCapital: false, coordinates: .init(lat: 10.0647, lng: -69.35703)),
        City(id: 2, name: "Carora", legalName: "Municipio Torres", isCapital: false, coordinates: .init(lat: 10.17283, lng: -70.081)),
        City(id: 3, name: "Cabudare", legalName: "Municipio Palavecino", isCapital: false, coordinates: .init(lat: 10.02658, lng: -69.26203)),
        City(id: 4, name: "El Tocuyo", legalName: "Municipio Morán", isCapital: false, coordinates: .init(lat: 9.78709, lng: -69.79294)),
    ]),
    Region(id: 7, name: "Bolívar", cities: [
        City(id: 1, name: "Ciudad Guayana", legalName: "Municipio Caroní", isCapital: false, coordinates: .init(lat: 8.35122, lng: -62.64102)),
        City(id: 2, name: "Ciudad Bolívar", legalName: "Municipio Heres", isCapital: false, coordinates: .init(lat: 8.12923, lng: -63.54086)),
        City(id: 3, name: "Upata", legalName: "Municipio Piar", isCapital: false, coordinates: .init(lat: 8.0162, lng: -62.40561)),
        City(id: 4, name: "Caicara del Orinoco", legalName: "Municipio Cedeño", isCapital: false, coordinates: .init(lat: 7.63501, lng: -66.16815)),
    ]),
    Region(id: 8, name: "Anzoátegui", cities: [
        City(id: 1, name: "Barcelona", legalName: "Municipio Aragua", isCapital: false, coordinates: .init(lat: 9.45588, lng: -64.82928)),
        City(id: 2, name: "Puerto La Cruz", legalName: "Municipio Juan Antonio Sotillo", isCapital: false, coordinates: .init(lat: 10.21382, lng: -64.6328)),
        City(id: 3, name: "El Tigre", legalName: "Municipio Simón Rodríguez", isCapital: false, coordinates: .init(lat: 8.88902, lng: -64.2527)),
        City(id: 4, name: "Anaco", legalName: "Municipio Montes", isCapital: false, coordinates: .init(lat: 10.25056, lng: -63.91938)),
    ]),
    Region(id: 9, name: "Táchira", cities: [
        City(id: 1, name: "San Cristóbal", legalName: "Municipio San Cristóbal", isCapital: false, coordinates: .init(lat: 7.76694, lng: -72.225)),
        City(id: 2, name: "Rubio", legalName: "Municipio Junín", isCapital: false, coordinates: .init(lat: 7.70156, lng: -72.35551)),
        City(id: 3, name: "San Antonio del Táchira", legalName: "Municipio Bolívar", isCapital: false, coordinates: .init(lat: 7.8112, lng: -72.44437)),
    ]),
    Region(id: 10, name: "Monagas", cities: [
        City(id: 1, name: "Maturín", legalName: "Municipio Maturín", isCapital: false, coordinates: .init(lat: 9.74569, lng: -63.18323)),
    ]),
    Region(id: 11, name: "Sucre", cities: [
        City(id: 1, name: "Cumaná", legalName: "Municipio Montes", isCapital: false, coordinates: .init(lat: 10.25056, lng: -63.91938)),
        City(id: 2, name: "Carúpano", legalName: "Municipio Bermúdez", isCapital: false, coordinates: .init(lat: 10.66516, lng: -63.25387)),
    ]),
    Region(id: 12, name: "Portuguesa", cities: [
        City(id: 1, name: "Acarigua", legalName: "Municipio Páez", isCapital: false, coordinates: .init(lat: 9.55451, lng: -69.19564)),
        City(id: 2, name: "Guanare", legalName: "Municipio Guanare", isCapital: false, coordinates: .init(lat: 9.04183, lng: -69.74206)),
    ]),
    Region(id: 13, name: "Falcón", cities: [
        City(id: 1, name: "Coro", legalName: "Municipio Valmore Rodríguez", isCapital: false, coordinates: .init(lat: 10.12061, lng: -71.04422)),
        City(id: 2, name: "Punto Fijo", legalName: "Municipio Carirubana", isCapital: false, coordinates: .init(lat: 11.69152, lng: -70.19918)),
    ]),
    Region(id: 14, name: "Mérida", cities: [
        City(id: 1, name: "Mérida", legalName: "Municipio Libertador", isCapital: false, coordinates: .init(lat: 8.58972, lng: -71.15611)),
        City(id: 2, name: "El Vigía", legalName: "Municipio Alberto Adriani", isCapital: false, coordinates: .init(lat: 8.6135, lng: -71.65702)),
    ]),
    Region(id: 15, name: "Barinas", cities: [
        City(id: 1, name: "Barinas", legalName: "Municipio Barinas", isCapital: false, coordinates: .init(lat: 8.5931, lng: -70.2261)),
    ]),
    Region(id: 16, name: "Guárico", cities: [
        City(id: 1, name: "San Juan de los Morros", legalName: "Municipio Juan Germán Roscio", isCapital: false, coordinates: .init(lat: 9.91152, lng: -67.35381)),
        City(id: 2, name: "Valle de la Pascua", legalName: "Municipio Leonardo Infante", isCapital: false, coordinates: .init(lat: 9.21554, lng: -66.00734)),
        City(id: 3, name: "Calabozo", legalName: "Municipio Francisco de Miranda", isCapital: false, coordinates: .init(lat: 8.92416, lng: -67.42929)),
    ]),
    Region(id: 17, name: "Trujillo", cities: [
        City(id: 1, name: "Valera", legalName: "Municipio Valera", isCapital: false, coordinates: .init(lat: 9.31778, lng: -70.60361)),
        City(id: 2, name: "Trujillo", legalName: "Municipio Trujillo", isCapital: false, coordinates: .init(lat: 9.36583, lng: -70.43694)),
    ]),
    Region(id: 18, name: "Yaracuy", cities: [
        City(id: 1, name: "San Felipe", legalName: "Municipio San Felipe", isCapital: false, coordinates: .init(lat: 10.33991, lng: -68.74247)),
    ]),
    Region(id: 19, name: "Nueva Esparta", cities: [
        City(id: 1, name: "Porlamar", legalName: "Municipio Mariño", isCapital: false, coordinates: .init(lat: 10.95771, lng: -63.86971)),
        City(id: 2, name: "La Asunción", legalName: "Municipio Arismendi", isCapital: false, coordinates: .init(lat: 11.03333, lng: -63.86278)),
    ]),
    Region(id: 20, name: "Apure", cities: [
        City(id: 1, name: "San Fernando de Apure", legalName: "Municipio San Fernando", isCapital: false, coordinates: .init(lat: 7.88782, lng: -67.47236)),
    ]),
    Region(id: 21, name: "La Guaira", cities: [
        City(id: 1, name: "La Guaira", legalName: "Municipio Vargas", isCapital: false, coordinates: .init(lat: 10.60156, lng: -66.93293)),
        City(id: 2, name: "Maiquetía", legalName: "Municipio Vargas", isCapital: false, coordinates: .init(lat: 10.5945, lng: -66.95624)),
    ]),
    Region(id: 22, name: "Cojedes", cities: [
        City(id: 1, name: "San Carlos", legalName: "Municipio Autónomo Río Negro", isCapital: false, coordinates: .init(lat: 1.92027, lng: -67.06089)),
    ]),
    Region(id: 23, name: "Delta Amacuro", cities: [
        City(id: 1, name: "Tucupita", legalName: "Municipio Tucupita", isCapital: false, coordinates: .init(lat: 9.05806, lng: -62.05)),
    ]),
    Region(id: 24, name: "Amazonas", cities: [
        City(id: 1, name: "Puerto Ayacucho", legalName: "Municipio Autónomo Atures", isCapital: false, coordinates: .init(lat: 5.66049, lng: -67.58343)),
    ]),
])
