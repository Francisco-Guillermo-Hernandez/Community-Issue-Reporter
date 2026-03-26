//
//  ChileCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let chile = Country(id: 4, name: "Chile", regions: [
    Region(id: 1, name: "Metropolitana de Santiago", cities: [
        City(id: 1, name: "Santiago"),
        City(id: 2, name: "Puente Alto"),
        City(id: 3, name: "Maipú"),
        City(id: 4, name: "La Florida"),
        City(id: 5, name: "San Bernardo"),
    ]),
    Region(id: 2, name: "Valparaíso", cities: [
        City(id: 1, name: "Valparaíso"),
        City(id: 2, name: "Viña del Mar"),
        City(id: 3, name: "Quilpué"),
        City(id: 4, name: "Villa Alemana"),
        City(id: 5, name: "San Antonio"),
    ]),
    Region(id: 3, name: "Biobío", cities: [
        City(id: 1, name: "Concepción"),
        City(id: 2, name: "Talcahuano"),
        City(id: 3, name: "Los Ángeles"),
        City(id: 4, name: "Coronel"),
        City(id: 5, name: "Chiguayante"),
    ]),
    Region(id: 4, name: "Maule", cities: [
        City(id: 1, name: "Talca"),
        City(id: 2, name: "Curicó"),
        City(id: 3, name: "Linares"),
        City(id: 4, name: "Constitución"),
    ]),
    Region(id: 5, name: "Araucanía", cities: [
        City(id: 1, name: "Temuco"),
        City(id: 2, name: "Padre Las Casas"),
        City(id: 3, name: "Angol"),
        City(id: 4, name: "Villarrica"),
    ]),
    Region(id: 6, name: "O'Higgins", cities: [
        City(id: 1, name: "Rancagua"),
        City(id: 2, name: "San Fernando"),
        City(id: 3, name: "Pichilemu"),
    ]),
    Region(id: 7, name: "Los Lagos", cities: [
        City(id: 1, name: "Puerto Montt"),
        City(id: 2, name: "Osorno"),
        City(id: 3, name: "Castro"),
    ]),
    Region(id: 8, name: "Coquimbo", cities: [
        City(id: 1, name: "La Serena"),
        City(id: 2, name: "Coquimbo"),
        City(id: 3, name: "Ovalle"),
    ]),
    Region(id: 9, name: "Antofagasta", cities: [
        City(id: 1, name: "Antofagasta"),
        City(id: 2, name: "Calama"),
        City(id: 3, name: "Tocopilla"),
    ]),
    Region(id: 10, name: "Atacama", cities: [
        City(id: 1, name: "Copiapó"),
        City(id: 2, name: "Vallenar"),
        City(id: 3, name: "Caldera"),
    ]),
    Region(id: 11, name: "Los Ríos", cities: [
        City(id: 1, name: "Valdivia"),
        City(id: 2, name: "La Unión"),
        City(id: 3, name: "Río Bueno"),
    ]),
    Region(id: 12, name: "Tarapacá", cities: [
        City(id: 1, name: "Iquique"),
        City(id: 2, name: "Alto Hospicio"),
        City(id: 3, name: "Pozo Almonte"),
    ]),
    Region(id: 13, name: "Arica y Parinacota", cities: [
        City(id: 1, name: "Arica"),
        City(id: 2, name: "Putre"),
    ]),
    Region(id: 14, name: "Magallanes", cities: [
        City(id: 1, name: "Punta Arenas"),
        City(id: 2, name: "Puerto Natales"),
        City(id: 3, name: "Porvenir"),
    ]),
    Region(id: 15, name: "Aysén", cities: [
        City(id: 1, name: "Coyhaique"),
        City(id: 2, name: "Puerto Aysén"),
    ]),
    Region(id: 16, name: "Ñuble", cities: [
        City(id: 1, name: "Chillán"),
        City(id: 2, name: "San Carlos"),
    ]),
])
