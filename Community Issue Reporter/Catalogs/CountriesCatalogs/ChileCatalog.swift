//
//  ChileCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let chile = Country(id: 4, name: "Chile", regions: [
    Region(id: 1, name: "Metropolitana de Santiago", cities: [
        City(id: 1, name: "Santiago", legalName: "Provincia de Santiago", isCapital: false, coordinates: .init(lat: -33.45694, lng: -70.64827)),
        City(id: 2, name: "Puente Alto", legalName: "Provincia de Cordillera", isCapital: false, coordinates: .init(lat: -33.61169, lng: -70.57577)),
        City(id: 3, name: "Maipú", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 4, name: "La Florida", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "San Bernardo", legalName: "Provincia de Maipo", isCapital: false, coordinates: .init(lat: -33.59217, lng: -70.6996)),
    ]),
    Region(id: 2, name: "Valparaíso", cities: [
        City(id: 1, name: "Valparaíso", legalName: "Provincia de Valparaíso", isCapital: false, coordinates: .init(lat: -33.036, lng: -71.62963)),
        City(id: 2, name: "Viña del Mar", legalName: "Provincia de Valparaíso", isCapital: false, coordinates: .init(lat: -33.02457, lng: -71.55183)),
        City(id: 3, name: "Quilpué", legalName: "Provincia de Marga Marga", isCapital: false, coordinates: .init(lat: -33.04752, lng: -71.44249)),
        City(id: 4, name: "Villa Alemana", legalName: "Provincia de Marga Marga", isCapital: false, coordinates: .init(lat: -33.04823, lng: -71.3729)),
        City(id: 5, name: "San Antonio", legalName: "San Antonio Province", isCapital: false, coordinates: .init(lat: -33.59473, lng: -71.60746)),
    ]),
    Region(id: 3, name: "Biobío", cities: [
        City(id: 1, name: "Concepción", legalName: "Provincia de Concepción", isCapital: false, coordinates: .init(lat: -36.82699, lng: -73.04977)),
        City(id: 2, name: "Talcahuano", legalName: "Provincia de Concepción", isCapital: false, coordinates: .init(lat: -36.72494, lng: -73.11684)),
        City(id: 3, name: "Los Ángeles", legalName: "Provincia de Biobío", isCapital: false, coordinates: .init(lat: -37.46973, lng: -72.35366)),
        City(id: 4, name: "Coronel", legalName: "Provincia de Concepción", isCapital: false, coordinates: .init(lat: -37.03386, lng: -73.14019)),
        City(id: 5, name: "Chiguayante", legalName: "Provincia de Concepción", isCapital: false, coordinates: .init(lat: -36.9256, lng: -73.02841)),
    ]),
    Region(id: 4, name: "Maule", cities: [
        City(id: 1, name: "Talca", legalName: "Provincia de Concepción", isCapital: false, coordinates: .init(lat: -36.72494, lng: -73.11684)),
        City(id: 2, name: "Curicó", legalName: "Provincia de Curicó", isCapital: false, coordinates: .init(lat: -34.98279, lng: -71.23943)),
        City(id: 3, name: "Linares", legalName: "Provincia de Linares", isCapital: false, coordinates: .init(lat: -35.84667, lng: -71.59308)),
        City(id: 4, name: "Constitución", legalName: "Provincia de Talca", isCapital: false, coordinates: .init(lat: -35.33321, lng: -72.41156)),
    ]),
    Region(id: 5, name: "Araucanía", cities: [
        City(id: 1, name: "Temuco", legalName: "Provincia de Cautín", isCapital: false, coordinates: .init(lat: -38.73965, lng: -72.59842)),
        City(id: 2, name: "Padre Las Casas", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Angol", legalName: "Provincia de Malleco", isCapital: false, coordinates: .init(lat: -37.79519, lng: -72.71636)),
        City(id: 4, name: "Villarrica", legalName: "Provincia de Cautín", isCapital: false, coordinates: .init(lat: -39.28569, lng: -72.2279)),
    ]),
    Region(id: 6, name: "O'Higgins", cities: [
        City(id: 1, name: "Rancagua", legalName: "Provincia de Cachapoal", isCapital: false, coordinates: .init(lat: -34.17083, lng: -70.74444)),
        City(id: 2, name: "San Fernando", legalName: "Provincia de Maipo", isCapital: false, coordinates: .init(lat: -33.59217, lng: -70.6996)),
        City(id: 3, name: "Pichilemu", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 7, name: "Los Lagos", cities: [
        City(id: 1, name: "Puerto Montt", legalName: "Provincia de Llanquihue", isCapital: false, coordinates: .init(lat: -41.4693, lng: -72.94237)),
        City(id: 2, name: "Osorno", legalName: "Provincia de Osorno", isCapital: false, coordinates: .init(lat: -40.57395, lng: -73.13348)),
        City(id: 3, name: "Castro", legalName: "Provincia de Chiloé", isCapital: false, coordinates: .init(lat: -42.4721, lng: -73.77319)),
    ]),
    Region(id: 8, name: "Coquimbo", cities: [
        City(id: 1, name: "La Serena", legalName: "Provincia de Elqui", isCapital: false, coordinates: .init(lat: -29.90591, lng: -71.25014)),
        City(id: 2, name: "Coquimbo", legalName: "Provincia de Elqui", isCapital: false, coordinates: .init(lat: -29.95332, lng: -71.33947)),
        City(id: 3, name: "Ovalle", legalName: "Provincia de Limarí", isCapital: false, coordinates: .init(lat: -30.60106, lng: -71.19901)),
    ]),
    Region(id: 9, name: "Antofagasta", cities: [
        City(id: 1, name: "Antofagasta", legalName: "Provincia de Antofagasta", isCapital: false, coordinates: .init(lat: -23.65236, lng: -70.3954)),
        City(id: 2, name: "Calama", legalName: "Provincia de El Loa", isCapital: false, coordinates: .init(lat: -22.45667, lng: -68.92371)),
        City(id: 3, name: "Tocopilla", legalName: "Provincia de Tocopilla", isCapital: false, coordinates: .init(lat: -22.09198, lng: -70.19792)),
    ]),
    Region(id: 10, name: "Atacama", cities: [
        City(id: 1, name: "Copiapó", legalName: "Provincia de Copiapó", isCapital: false, coordinates: .init(lat: -27.36679, lng: -70.3314)),
        City(id: 2, name: "Vallenar", legalName: "Provincia de Huasco", isCapital: false, coordinates: .init(lat: -28.57617, lng: -70.75938)),
        City(id: 3, name: "Caldera", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 11, name: "Los Ríos", cities: [
        City(id: 1, name: "Valdivia", legalName: "Provincia de Valdivia", isCapital: false, coordinates: .init(lat: -39.81422, lng: -73.24589)),
        City(id: 2, name: "La Unión", legalName: "Provincia del Ranco", isCapital: false, coordinates: .init(lat: -40.29313, lng: -73.08167)),
        City(id: 3, name: "Río Bueno", legalName: "Provincia del Ranco", isCapital: false, coordinates: .init(lat: -40.33494, lng: -72.95564)),
    ]),
    Region(id: 12, name: "Tarapacá", cities: [
        City(id: 1, name: "Iquique", legalName: "Provincia de Iquique", isCapital: false, coordinates: .init(lat: -20.21326, lng: -70.15027)),
        City(id: 2, name: "Alto Hospicio", legalName: "Provincia de Iquique", isCapital: false, coordinates: .init(lat: -20.26871, lng: -70.1049)),
        City(id: 3, name: "Pozo Almonte", legalName: "Provincia del Tamarugal", isCapital: false, coordinates: .init(lat: -20.25585, lng: -69.7863)),
    ]),
    Region(id: 13, name: "Arica y Parinacota", cities: [
        City(id: 1, name: "Arica", legalName: "Provincia de Arica", isCapital: false, coordinates: .init(lat: -18.4746, lng: -70.29792)),
        City(id: 2, name: "Putre", legalName: "Provincia de Parinacota", isCapital: false, coordinates: .init(lat: -18.19821, lng: -69.56071)),
    ]),
    Region(id: 14, name: "Magallanes", cities: [
        City(id: 1, name: "Punta Arenas", legalName: "Provincia de Magallanes", isCapital: false, coordinates: .init(lat: -53.15483, lng: -70.91129)),
        City(id: 2, name: "Puerto Natales", legalName: "Provincia de Última Esperanza", isCapital: false, coordinates: .init(lat: -51.72987, lng: -72.50603)),
        City(id: 3, name: "Porvenir", legalName: "Provincia de Tierra del Fuego", isCapital: false, coordinates: .init(lat: -53.296, lng: -70.36629)),
    ]),
    Region(id: 15, name: "Aysén", cities: [
        City(id: 1, name: "Coyhaique", legalName: "Provincia de Coyhaique", isCapital: false, coordinates: .init(lat: -45.57524, lng: -72.06619)),
        City(id: 2, name: "Puerto Aysén", legalName: "Provincia de Aisén", isCapital: false, coordinates: .init(lat: -45.40303, lng: -72.69184)),
    ]),
    Region(id: 16, name: "Ñuble", cities: [
        City(id: 1, name: "Chillán", legalName: "Provincia de Diguillín", isCapital: false, coordinates: .init(lat: -36.60664, lng: -72.10344)),
        City(id: 2, name: "San Carlos", legalName: "Provincia de Punilla", isCapital: false, coordinates: .init(lat: -36.42477, lng: -71.958)),
    ]),
])
