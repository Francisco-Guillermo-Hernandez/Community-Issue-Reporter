//
//  BoliviaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let bolivia = Country(id: 2, name: "Bolivia", regions: [
    Region(id: 1, name: "Santa Cruz", cities: [
        City(id: 1, name: "Santa Cruz de la Sierra", legalName: "", isCapital: false, coordinates: .init(lat: -17.78629, lng: -63.18117)),
        City(id: 2, name: "Montero", legalName: "", isCapital: false, coordinates: .init(lat: -17.33874, lng: -63.25093)),
        City(id: 3, name: "Warnes", legalName: "", isCapital: false, coordinates: .init(lat: -17.5163, lng: -63.16778)),
        City(id: 4, name: "La Guardia", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "El Torno", legalName: "", isCapital: false, coordinates: .init(lat: -18.00014, lng: -63.38712)),
        City(id: 6, name: "Cotoca", legalName: "", isCapital: false, coordinates: .init(lat: -17.81667, lng: -63.05)),
    ]),
    Region(id: 2, name: "La Paz", cities: [
        City(id: 1, name: "La Paz", legalName: "", isCapital: false, coordinates: .init(lat: -16.5, lng: -68.15)),
        City(id: 2, name: "El Alto", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Viacha", legalName: "Provincia Ingavi", isCapital: false, coordinates: .init(lat: -16.65, lng: -68.3)),
        City(id: 4, name: "Caranavi", legalName: "", isCapital: false, coordinates: .init(lat: -15.83403, lng: -67.56586)),
        City(id: 5, name: "Patacamaya", legalName: "", isCapital: false, coordinates: .init(lat: -17.23611, lng: -67.91443)),
    ]),
    Region(id: 3, name: "Cochabamba", cities: [
        City(id: 1, name: "Cochabamba", legalName: "", isCapital: false, coordinates: .init(lat: -17.3895, lng: -66.1568)),
        City(id: 2, name: "Quillacollo", legalName: "", isCapital: false, coordinates: .init(lat: -17.39228, lng: -66.27838)),
        City(id: 3, name: "Sacaba", legalName: "", isCapital: false, coordinates: .init(lat: -17.39799, lng: -66.03825)),
        City(id: 4, name: "Tiquipaya", legalName: "", isCapital: false, coordinates: .init(lat: -17.33801, lng: -66.21579)),
        City(id: 5, name: "Colcapirhua", legalName: "", isCapital: false, coordinates: .init(lat: -17.3857, lng: -66.23814)),
        City(id: 6, name: "Vinto", legalName: "", isCapital: false, coordinates: .init(lat: -17.39141, lng: -66.31681)),
    ]),
    Region(id: 4, name: "Chuquisaca", cities: [
        City(id: 1, name: "Sucre", legalName: "", isCapital: false, coordinates: .init(lat: -19.03332, lng: -65.26274)),
        City(id: 2, name: "Monteagudo", legalName: "", isCapital: false, coordinates: .init(lat: -19.79998, lng: -63.95617)),
        City(id: 3, name: "Camargo", legalName: "Provincia Nor Cinti", isCapital: false, coordinates: .init(lat: -20.64064, lng: -65.20893)),
        City(id: 4, name: "Tarabuco", legalName: "Provincia Yamparáez", isCapital: false, coordinates: .init(lat: -19.18168, lng: -64.91517)),
    ]),
    Region(id: 5, name: "Oruro", cities: [
        City(id: 1, name: "Oruro", legalName: "", isCapital: false, coordinates: .init(lat: -17.98333, lng: -67.15)),
        City(id: 2, name: "Challapata", legalName: "", isCapital: false, coordinates: .init(lat: -18.90208, lng: -66.77048)),
        City(id: 3, name: "Huanuni", legalName: "", isCapital: false, coordinates: .init(lat: -18.289, lng: -66.83583)),
    ]),
    Region(id: 6, name: "Potosí", cities: [
        City(id: 1, name: "Potosí", legalName: "", isCapital: false, coordinates: .init(lat: -19.58361, lng: -65.75306)),
        City(id: 2, name: "Villazón", legalName: "", isCapital: false, coordinates: .init(lat: -22.08659, lng: -65.59422)),
        City(id: 3, name: "Uyuni", legalName: "", isCapital: false, coordinates: .init(lat: -20.45967, lng: -66.82503)),
        City(id: 4, name: "Tupiza", legalName: "", isCapital: false, coordinates: .init(lat: -21.44345, lng: -65.71875)),
    ]),
    Region(id: 7, name: "Tarija", cities: [
        City(id: 1, name: "Tarija", legalName: "", isCapital: false, coordinates: .init(lat: -21.53549, lng: -64.72956)),
        City(id: 2, name: "Yacuiba", legalName: "Provincia Gran Chaco", isCapital: false, coordinates: .init(lat: -22.01643, lng: -63.67753)),
        City(id: 3, name: "Bermejo", legalName: "", isCapital: false, coordinates: .init(lat: -22.73206, lng: -64.33724)),
        City(id: 4, name: "Villamontes", legalName: "", isCapital: false, coordinates: .init(lat: -21.26235, lng: -63.46903)),
    ]),
    Region(id: 8, name: "Beni", cities: [
        City(id: 1, name: "Trinidad", legalName: "", isCapital: false, coordinates: .init(lat: -14.83333, lng: -64.9)),
        City(id: 2, name: "Riberalta", legalName: "Provincia Vaca Diez", isCapital: false, coordinates: .init(lat: -11.01026, lng: -66.05257)),
        City(id: 3, name: "Guayaramerín", legalName: "Provincia Vaca Diez", isCapital: false, coordinates: .init(lat: -10.8258, lng: -65.3581)),
        City(id: 4, name: "San Borja", legalName: "", isCapital: false, coordinates: .init(lat: -14.85195, lng: -66.74954)),
    ]),
    Region(id: 9, name: "Pando", cities: [
        City(id: 1, name: "Cobija", legalName: "", isCapital: false, coordinates: .init(lat: -11.02671, lng: -68.76918)),
        City(id: 2, name: "Porvenir", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Puerto Rico", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
])
