//
//  PanamaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let panama = Country(id: 6, name: "Panama", regions: [
    Region(id: 1, name: "Panamá", cities: [
        City(id: 1, name: "Panama City", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "San Miguelito", legalName: "Distrito de San Miguelito", coordinates: .init(lat: 9.05032, lng: -79.47068)),
        City(id: 3, name: "Chepo", legalName: "Distrito de Chepo", coordinates: .init(lat: 9.17019, lng: -79.10083)),
        City(id: 4, name: "Pacora", legalName: "Distrito de Panamá", coordinates: .init(lat: 9.08252, lng: -79.28957)),
        City(id: 5, name: "San Martín", legalName: "", coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 2, name: "Panamá Oeste", cities: [
        City(id: 1, name: "La Chorrera", legalName: "Distrito de La Chorrera", coordinates: .init(lat: 8.88028, lng: -79.78333)),
        City(id: 2, name: "Arraiján", legalName: "Distrito de Arraiján", coordinates: .init(lat: 8.92643, lng: -79.72023)),
        City(id: 3, name: "Capira", legalName: "Distrito de Capira", coordinates: .init(lat: 8.7584, lng: -79.8776)),
        City(id: 4, name: "Chame", legalName: "Distrito de Chame", coordinates: .init(lat: 8.58148, lng: -79.88433)),
        City(id: 5, name: "San Carlos", legalName: "Distrito de David", coordinates: .init(lat: 8.5205, lng: -82.50465)),
    ]),
    Region(id: 3, name: "Chiriquí", cities: [
        City(id: 1, name: "David", legalName: "Distrito de David", coordinates: .init(lat: 8.42729, lng: -82.43085)),
        City(id: 2, name: "Bugaba", legalName: "Distrito de Bugaba", coordinates: .init(lat: 8.48606, lng: -82.62023)),
        City(id: 3, name: "Boquete", legalName: "Distrito de Boquete", coordinates: .init(lat: 8.78024, lng: -82.44136)),
        City(id: 4, name: "Barú", legalName: "Distrito de La Mesa", coordinates: .init(lat: 8.17201, lng: -81.30121)),
        City(id: 5, name: "Alanje", legalName: "Distrito de Alanje", coordinates: .init(lat: 8.39997, lng: -82.55873)),
    ]),
    Region(id: 4, name: "Colón", cities: [
        City(id: 1, name: "Colón", legalName: "Distrito de Colón", coordinates: .init(lat: 9.35451, lng: -79.90011)),
        City(id: 2, name: "Portobelo", legalName: "Distrito de Portobelo", coordinates: .init(lat: 9.55303, lng: -79.65693)),
        City(id: 3, name: "Chagres", legalName: "Distrito de Chagres", coordinates: .init(lat: 9.23979, lng: -80.08267)),
        City(id: 4, name: "Donoso", legalName: "Distrito de Tonosí", coordinates: .init(lat: 7.40718, lng: -80.43936)),
        City(id: 5, name: "Santa Isabel", legalName: "Distrito de Santa Isabel", coordinates: .init(lat: 9.53922, lng: -79.1957)),
    ]),
    Region(id: 5, name: "Coclé", cities: [
        City(id: 1, name: "Penonomé", legalName: "Distrito Penonomé", coordinates: .init(lat: 8.51889, lng: -80.35727)),
        City(id: 2, name: "Aguadulce", legalName: "Distrito de Aguadulce", coordinates: .init(lat: 8.24146, lng: -80.53978)),
        City(id: 3, name: "Antón", legalName: "Distrito de Atalaya", coordinates: .init(lat: 8.0722, lng: -80.92971)),
        City(id: 4, name: "Natá", legalName: "Distrito de Natá", coordinates: .init(lat: 8.33588, lng: -80.5213)),
        City(id: 5, name: "Olá", legalName: "Distrito de Las Palmas", coordinates: .init(lat: 8.09263, lng: -81.46653)),
        City(id: 6, name: "La Pintada", legalName: "Distrito de La Pintada", coordinates: .init(lat: 8.59616, lng: -80.44693)),
    ]),
    Region(id: 6, name: "Veraguas", cities: [
        City(id: 1, name: "Santiago", legalName: "Distrito de Santiago", coordinates: .init(lat: 8.1, lng: -80.98333)),
        City(id: 2, name: "Soná", legalName: "Distrito de Soná", coordinates: .init(lat: 8.00877, lng: -81.31727)),
        City(id: 3, name: "Atalaya", legalName: "Distrito de Atalaya", coordinates: .init(lat: 8.04358, lng: -80.92482)),
        City(id: 4, name: "Calobre", legalName: "Distrito de Calobre", coordinates: .init(lat: 8.22062, lng: -80.8256)),
        City(id: 5, name: "Cañazas", legalName: "Distrito de Cañazas", coordinates: .init(lat: 8.32004, lng: -81.21152)),
    ]),
    Region(id: 7, name: "Herrera", cities: [
        City(id: 1, name: "Chitré", legalName: "Distrito de Chitré", coordinates: .init(lat: 7.96082, lng: -80.42944)),
        City(id: 2, name: "Ocú", legalName: "Distrito de Ocú", coordinates: .init(lat: 7.94525, lng: -80.7773)),
        City(id: 3, name: "Pesé", legalName: "Distrito de Pesé", coordinates: .init(lat: 7.90863, lng: -80.61433)),
        City(id: 4, name: "Parita", legalName: "Distrito de Chitré", coordinates: .init(lat: 8.01114, lng: -80.45065)),
        City(id: 5, name: "Las Minas", legalName: "Distrito de Las Minas", coordinates: .init(lat: 7.79947, lng: -80.74573)),
    ]),
    Region(id: 8, name: "Los Santos", cities: [
        City(id: 1, name: "Las Tablas", legalName: "Distrito de Las Tablas", coordinates: .init(lat: 7.76472, lng: -80.27483)),
        City(id: 2, name: "Los Santos", legalName: "Distrito de Los Santos", coordinates: .init(lat: 7.93445, lng: -80.41218)),
        City(id: 3, name: "Guararé", legalName: "Distrito de Guararé", coordinates: .init(lat: 7.80798, lng: -80.35919)),
        City(id: 4, name: "Macaracas", legalName: "Distrito de Macaracas", coordinates: .init(lat: 7.73168, lng: -80.55364)),
        City(id: 5, name: "Pocri", legalName: "Distrito de Pocrí", coordinates: .init(lat: 7.66022, lng: -80.11946)),
    ]),
    Region(id: 9, name: "Bocas del Toro", cities: [
        City(id: 1, name: "Bocas del Toro", legalName: "Distrito de Bocas del Toro", coordinates: .init(lat: 9.34031, lng: -82.24204)),
        City(id: 2, name: "Changuinola", legalName: "Distrito de Changuinola", coordinates: .init(lat: 9.43, lng: -82.52)),
        City(id: 3, name: "Almirante", legalName: "", coordinates: .init(lat: 9.30091, lng: -82.4018)),
        City(id: 4, name: "Chiriquí Grande", legalName: "Distrito Chiriquí Grande", coordinates: .init(lat: 8.94938, lng: -82.11707)),
    ]),
    Region(id: 10, name: "Darién", cities: [
        City(id: 1, name: "La Palma", legalName: "Distrito de Guararé", coordinates: .init(lat: 7.72857, lng: -80.38226)),
        City(id: 2, name: "Metetí", legalName: "Distrito de Pinogana", coordinates: .init(lat: 8.49909, lng: -77.97897)),
        City(id: 3, name: "Pinogana", legalName: "Distrito de Pinogana", coordinates: .init(lat: 8.11724, lng: -77.68307)),
        City(id: 4, name: "Chepigana", legalName: "Distrito de Chepigana", coordinates: .init(lat: 8.28445, lng: -78.04189)),
    ]),
])
