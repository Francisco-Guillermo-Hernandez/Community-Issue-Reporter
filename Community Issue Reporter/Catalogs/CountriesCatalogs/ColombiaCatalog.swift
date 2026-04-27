//
//  ColombiaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let colombia = Country(id: 5, name: "Colombia", regions: [
    Region(id: 1, name: "Bogotá D.C.", cities: [
        City(id: 1, name: "Bogotá", legalName: "", isCapital: false, coordinates: .init(lat: 5.19994, lng: -74.72733)),
    ]),
    Region(id: 2, name: "Antioquia", cities: [
        City(id: 1, name: "Medellín", legalName: "", isCapital: false, coordinates: .init(lat: 6.25184, lng: -75.56359)),
        City(id: 2, name: "Bello", legalName: "", isCapital: false, coordinates: .init(lat: 5.94806, lng: -75.5275)),
        City(id: 3, name: "Itagüí", legalName: "Itagui", isCapital: false, coordinates: .init(lat: 6.18461, lng: -75.59913)),
        City(id: 4, name: "Envigado", legalName: "", isCapital: false, coordinates: .init(lat: 6.17591, lng: -75.59174)),
        City(id: 5, name: "Rionegro", legalName: "", isCapital: false, coordinates: .init(lat: 6.15515, lng: -75.37371)),
        City(id: 6, name: "Apartadó", legalName: "", isCapital: false, coordinates: .init(lat: 7.88299, lng: -76.62587)),
        City(id: 7, name: "Turbo", legalName: "", isCapital: false, coordinates: .init(lat: 8.09263, lng: -76.72822)),
        City(id: 8, name: "Caucasia", legalName: "", isCapital: false, coordinates: .init(lat: 7.98654, lng: -75.19349)),
    ]),
    Region(id: 3, name: "Valle del Cauca", cities: [
        City(id: 1, name: "Cali", legalName: "", isCapital: false, coordinates: .init(lat: 3.43722, lng: -76.5225)),
        City(id: 2, name: "Buenaventura", legalName: "", isCapital: false, coordinates: .init(lat: 3.58333, lng: -77)),
        City(id: 3, name: "Palmira", legalName: "", isCapital: false, coordinates: .init(lat: 3.53944, lng: -76.30361)),
        City(id: 4, name: "Tuluá", legalName: "", isCapital: false, coordinates: .init(lat: 4.08466, lng: -76.19536)),
        City(id: 5, name: "Buga", legalName: "", isCapital: false, coordinates: .init(lat: 3.90089, lng: -76.29783)),
        City(id: 6, name: "Cartago", legalName: "", isCapital: false, coordinates: .init(lat: 1.55151, lng: -77.11948)),
        City(id: 7, name: "Jamundí", legalName: "", isCapital: false, coordinates: .init(lat: 3.26074, lng: -76.53499)),
        City(id: 8, name: "Yumbo", legalName: "", isCapital: false, coordinates: .init(lat: 3.58234, lng: -76.49146)),
    ]),
    Region(id: 4, name: "Atlántico", cities: [
        City(id: 1, name: "Barranquilla", legalName: "", isCapital: false, coordinates: .init(lat: 10.96854, lng: -74.78132)),
        City(id: 2, name: "Soledad", legalName: "", isCapital: false, coordinates: .init(lat: 10.91843, lng: -74.76459)),
        City(id: 3, name: "Malambo", legalName: "", isCapital: false, coordinates: .init(lat: 10.85953, lng: -74.77386)),
        City(id: 4, name: "Sabanalarga", legalName: "", isCapital: false, coordinates: .init(lat: 6.84893, lng: -75.81711)),
        City(id: 5, name: "Puerto Colombia", legalName: "", isCapital: false, coordinates: .init(lat: 10.98778, lng: -74.95472)),
    ]),
    Region(id: 5, name: "Bolívar", cities: [
        City(id: 1, name: "Cartagena", legalName: "", isCapital: false, coordinates: .init(lat: 1.33488, lng: -74.84289)),
        City(id: 2, name: "Magangué", legalName: "", isCapital: false, coordinates: .init(lat: 9.24202, lng: -74.75467)),
        City(id: 3, name: "El Carmen de Bolívar", legalName: "", isCapital: false, coordinates: .init(lat: 9.7174, lng: -75.12023)),
        City(id: 4, name: "Turbaco", legalName: "", isCapital: false, coordinates: .init(lat: 10.32944, lng: -75.41137)),
        City(id: 5, name: "Arjona", legalName: "", isCapital: false, coordinates: .init(lat: 10.25444, lng: -75.34389)),
    ]),
    Region(id: 6, name: "Santander", cities: [
        City(id: 1, name: "Bucaramanga", legalName: "", isCapital: false, coordinates: .init(lat: 7.12539, lng: -73.1198)),
        City(id: 2, name: "Floridablanca", legalName: "", isCapital: false, coordinates: .init(lat: 7.06222, lng: -73.08644)),
        City(id: 3, name: "Barrancabermeja", legalName: "", isCapital: false, coordinates: .init(lat: 7.06528, lng: -73.85472)),
        City(id: 4, name: "Girón", legalName: "", isCapital: false, coordinates: .init(lat: 7.0682, lng: -73.16981)),
        City(id: 5, name: "Piedecuesta", legalName: "", isCapital: false, coordinates: .init(lat: 6.98789, lng: -73.04953)),
    ]),
    Region(id: 7, name: "Cundinamarca", cities: [
        City(id: 1, name: "Soacha", legalName: "", isCapital: false, coordinates: .init(lat: 4.57937, lng: -74.21682)),
        City(id: 2, name: "Fusagasugá", legalName: "", isCapital: false, coordinates: .init(lat: 4.33646, lng: -74.36378)),
        City(id: 3, name: "Facatativá", legalName: "", isCapital: false, coordinates: .init(lat: 4.81367, lng: -74.35453)),
        City(id: 4, name: "Girardot", legalName: "Girardot", isCapital: false, coordinates: .init(lat: 4.30079, lng: -74.80754)),
        City(id: 5, name: "Chía", legalName: "", isCapital: false, coordinates: .init(lat: 4.85876, lng: -74.05866)),
        City(id: 6, name: "Zipaquirá", legalName: "", isCapital: false, coordinates: .init(lat: 5.02208, lng: -74.00481)),
        City(id: 7, name: "Mosquera", legalName: "", isCapital: false, coordinates: .init(lat: 2.50861, lng: -78.4511)),
        City(id: 8, name: "Madrid", legalName: "", isCapital: false, coordinates: .init(lat: 4.73245, lng: -74.26419)),
    ]),
    Region(id: 8, name: "Nariño", cities: [
        City(id: 1, name: "Pasto", legalName: "", isCapital: false, coordinates: .init(lat: 1.21361, lng: -77.28111)),
        City(id: 2, name: "Tumaco", legalName: "San Andres de Tumaco", isCapital: false, coordinates: .init(lat: 1.79112, lng: -78.79275)),
        City(id: 3, name: "Ipiales", legalName: "", isCapital: false, coordinates: .init(lat: 0.82501, lng: -77.63966)),
    ]),
    Region(id: 9, name: "Córdoba", cities: [
        City(id: 1, name: "Montería", legalName: "", isCapital: false, coordinates: .init(lat: 8.74798, lng: -75.88143)),
        City(id: 2, name: "Cereté", legalName: "", isCapital: false, coordinates: .init(lat: 8.88479, lng: -75.79052)),
        City(id: 3, name: "Sahagún", legalName: "", isCapital: false, coordinates: .init(lat: 8.94617, lng: -75.44275)),
        City(id: 4, name: "Lorica", legalName: "", isCapital: false, coordinates: .init(lat: 9.23648, lng: -75.8135)),
        City(id: 5, name: "Montelíbano", legalName: "", isCapital: false, coordinates: .init(lat: 7.97917, lng: -75.4202)),
    ]),
    Region(id: 10, name: "Tolima", cities: [
        City(id: 1, name: "Ibagué", legalName: "", isCapital: false, coordinates: .init(lat: 4.43889, lng: -75.23222)),
        City(id: 2, name: "Espinal", legalName: "", isCapital: false, coordinates: .init(lat: 4.14924, lng: -74.88429)),
        City(id: 3, name: "Melgar", legalName: "", isCapital: false, coordinates: .init(lat: 4.20475, lng: -74.64075)),
        City(id: 4, name: "Mariquita", legalName: "Municipio de San Sebastián de Mariquita", isCapital: false, coordinates: .init(lat: 5.19889, lng: -74.89295)),
    ]),
])
