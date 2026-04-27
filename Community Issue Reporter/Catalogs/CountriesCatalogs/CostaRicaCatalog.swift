//
//  CostaRicaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let costaRica = Country(id: 5, name: "Costa Rica", regions: [
    Region(id: 1, name: "San José", cities: [
        City(id: 1, name: "San José", legalName: "", isCapital: false, coordinates: .init(lat: 9.93333, lng: -84.08333)),
        City(id: 2, name: "Escazú", legalName: "", isCapital: false, coordinates: .init(lat: 9.91887, lng: -84.13989)),
        City(id: 3, name: "Desamparados", legalName: "San Mateo", isCapital: false, coordinates: .init(lat: 9.94727, lng: -84.50626)),
        City(id: 4, name: "Puriscal", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Tibás", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 6, name: "Goicoechea", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 7, name: "Santa Ana", legalName: "", isCapital: false, coordinates: .init(lat: 9.9326, lng: -84.18255)),
        City(id: 8, name: "Alajuelita", legalName: "", isCapital: false, coordinates: .init(lat: 9.90294, lng: -84.10037)),
        City(id: 9, name: "Vázquez de Coronado", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 10, name: "Moravia", legalName: "Moravia", isCapital: false, coordinates: .init(lat: 9.96164, lng: -84.0488)),
    ]),
    Region(id: 2, name: "Alajuela", cities: [
        City(id: 1, name: "Alajuela", legalName: "", isCapital: false, coordinates: .init(lat: 10.01625, lng: -84.21163)),
        City(id: 2, name: "San Ramón", legalName: "", isCapital: false, coordinates: .init(lat: 10.08802, lng: -84.47022)),
        City(id: 3, name: "Grecia", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "San Carlos", legalName: "Tarrazú", isCapital: false, coordinates: .init(lat: 9.6601, lng: -84.02026)),
        City(id: 5, name: "Naranjo", legalName: "", isCapital: false, coordinates: .init(lat: 10.09866, lng: -84.37824)),
        City(id: 6, name: "Palmares", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 7, name: "Poás", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 8, name: "Orotina", legalName: "", isCapital: false, coordinates: .init(lat: 9.91193, lng: -84.52337)),
    ]),
    Region(id: 3, name: "Cartago", cities: [
        City(id: 1, name: "Cartago", legalName: "", isCapital: false, coordinates: .init(lat: 9.86444, lng: -83.91944)),
        City(id: 2, name: "Paraíso", legalName: "", isCapital: false, coordinates: .init(lat: 9.83847, lng: -83.86655)),
        City(id: 3, name: "La Unión", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "Jiménez", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Turrialba", legalName: "", isCapital: false, coordinates: .init(lat: 9.90371, lng: -83.68361)),
        City(id: 6, name: "Alvarado", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 7, name: "Oreamuno", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 8, name: "El Guarco", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 4, name: "Heredia", cities: [
        City(id: 1, name: "Heredia", legalName: "", isCapital: false, coordinates: .init(lat: 10.00236, lng: -84.11651)),
        City(id: 2, name: "Barva", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Santo Domingo", legalName: "Santa Bárbara", isCapital: false, coordinates: .init(lat: 10.06389, lng: -84.15499)),
        City(id: 4, name: "Santa Bárbara", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "San Rafael", legalName: "Puriscal", isCapital: false, coordinates: .init(lat: 9.831, lng: -84.29008)),
        City(id: 6, name: "San Isidro", legalName: "Pérez Zeledón", isCapital: false, coordinates: .init(lat: 9.3674, lng: -83.69713)),
        City(id: 7, name: "Belén", legalName: "Carrillo", isCapital: false, coordinates: .init(lat: 10.40789, lng: -85.58836)),
        City(id: 8, name: "Flores", legalName: "Pérez Zeledón", isCapital: false, coordinates: .init(lat: 9.33607, lng: -83.66999)),
        City(id: 9, name: "San Pablo", legalName: "León Cortés Castro", isCapital: false, coordinates: .init(lat: 9.68323, lng: -84.0405)),
        City(id: 10, name: "Sarapiquí", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 5, name: "Guanacaste", cities: [
        City(id: 1, name: "Liberia", legalName: "", isCapital: false, coordinates: .init(lat: 10.63504, lng: -85.43772)),
        City(id: 2, name: "Nicoya", legalName: "", isCapital: false, coordinates: .init(lat: 10.15038, lng: -85.45093)),
        City(id: 3, name: "Santa Cruz", legalName: "", isCapital: false, coordinates: .init(lat: 10.26053, lng: -85.5851)),
        City(id: 4, name: "Bagaces", legalName: "", isCapital: false, coordinates: .init(lat: 10.52541, lng: -85.25537)),
        City(id: 5, name: "Cañas", legalName: "", isCapital: false, coordinates: .init(lat: 10.43105, lng: -85.09825)),
        City(id: 6, name: "Abangares", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 7, name: "Tilarán", legalName: "", isCapital: false, coordinates: .init(lat: 10.46701, lng: -84.96775)),
        City(id: 8, name: "Nandayure", legalName: "", isCapital: false, coordinates: .init(lat: 10.03333, lng: -85.2)),
    ]),
    Region(id: 6, name: "Puntarenas", cities: [
        City(id: 1, name: "Puntarenas", legalName: "", isCapital: false, coordinates: .init(lat: 9.97691, lng: -84.8379)),
        City(id: 2, name: "Esparza", legalName: "", isCapital: false, coordinates: .init(lat: 9.99197, lng: -84.66628)),
        City(id: 3, name: "Buenos Aires", legalName: "", isCapital: false, coordinates: .init(lat: 9.17298, lng: -83.33277)),
        City(id: 4, name: "Montes de Oro", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Osa", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 6, name: "Quepos", legalName: "", isCapital: false, coordinates: .init(lat: 9.43063, lng: -84.16231)),
        City(id: 7, name: "Golfito", legalName: "", isCapital: false, coordinates: .init(lat: 8.60327, lng: -83.11342)),
        City(id: 8, name: "Coto Brus", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 9, name: "Parrita", legalName: "", isCapital: false, coordinates: .init(lat: 9.52166, lng: -84.32289)),
        City(id: 10, name: "Garabito", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "Limón", cities: [
        City(id: 1, name: "Limón", legalName: "", isCapital: false, coordinates: .init(lat: 9.99074, lng: -83.03596)),
        City(id: 2, name: "Pococí", legalName: "Guácimo", isCapital: false, coordinates: .init(lat: 10.17195, lng: -83.60264)),
        City(id: 3, name: "Siquirres", legalName: "", isCapital: false, coordinates: .init(lat: 10.09748, lng: -83.50659)),
        City(id: 4, name: "Talamanca", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Matina", legalName: "", isCapital: false, coordinates: .init(lat: 10.08363, lng: -83.28431)),
        City(id: 6, name: "Guácimo", legalName: "", isCapital: false, coordinates: .init(lat: 10.2129, lng: -83.68793)),
    ]),
])
