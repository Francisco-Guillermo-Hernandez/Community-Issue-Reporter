//
//  ArgentinaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let argentina = Country(id: 1, name: "Argentina", regions: [
    Region(id: 1, name: "Buenos Aires", cities: [
        City(id: 1, name: "La Plata"),
        City(id: 2, name: "Mar del Plata"),
        City(id: 3, name: "Bahía Blanca"),
        City(id: 4, name: "Lanús"),
        City(id: 5, name: "Quilmes"),
        City(id: 6, name: "Tandil"),
        City(id: 7, name: "Pilar"),
        City(id: 8, name: "San Nicolás"),
        City(id: 9, name: "Pergamino"),
        City(id: 10, name: "Olavarría"),
    ]),
    Region(id: 2, name: "Córdoba", cities: [
        City(id: 1, name: "Córdoba"),
        City(id: 2, name: "Río Cuarto"),
        City(id: 3, name: "Villa María"),
        City(id: 4, name: "Villa Carlos Paz"),
        City(id: 5, name: "San Francisco"),
        City(id: 6, name: "Alta Gracia"),
        City(id: 7, name: "Río Tercero"),
    ]),
    Region(id: 3, name: "Santa Fe", cities: [
        City(id: 1, name: "Rosario"),
        City(id: 2, name: "Santa Fe"),
        City(id: 3, name: "Rafaela"),
        City(id: 4, name: "Venado Tuerto"),
        City(id: 5, name: "Reconquista"),
        City(id: 6, name: "Santo Tomé"),
        City(id: 7, name: "Villa Constitución"),
    ]),
    Region(id: 4, name: "Ciudad Autónoma de Buenos Aires", cities: [
        City(id: 1, name: "Buenos Aires"),
    ]),
    Region(id: 5, name: "Mendoza", cities: [
        City(id: 1, name: "Mendoza"),
        City(id: 2, name: "San Rafael"),
        City(id: 3, name: "Godoy Cruz"),
        City(id: 4, name: "Guaymallén"),
        City(id: 5, name: "Las Heras"),
        City(id: 6, name: "Luján de Cuyo"),
    ]),
    Region(id: 6, name: "Tucumán", cities: [
        City(id: 1, name: "San Miguel de Tucumán"),
        City(id: 2, name: "Yerba Buena"),
        City(id: 3, name: "Tafí Viejo"),
        City(id: 4, name: "Concepción"),
        City(id: 5, name: "Alderetes"),
    ]),
    Region(id: 7, name: "Entre Ríos", cities: [
        City(id: 1, name: "Paraná"),
        City(id: 2, name: "Concordia"),
        City(id: 3, name: "Gualeguaychú"),
        City(id: 4, name: "Concepción del Uruguay"),
        City(id: 5, name: "Gualeguay"),
    ]),
    Region(id: 8, name: "Salta", cities: [
        City(id: 1, name: "Salta"),
        City(id: 2, name: "San Ramón de la Nueva Orán"),
        City(id: 3, name: "Tartagal"),
        City(id: 4, name: "General Güemes"),
        City(id: 5, name: "Rosario de Lerma"),
    ]),
    Region(id: 9, name: "Chaco", cities: [
        City(id: 1, name: "Resistencia"),
        City(id: 2, name: "Presidencia Roque Sáenz Peña"),
        City(id: 3, name: "Villa Ángela"),
        City(id: 4, name: "Charata"),
        City(id: 5, name: "Juan José Castelli"),
    ]),
    Region(id: 10, name: "Misiones", cities: [
        City(id: 1, name: "Posadas"),
        City(id: 2, name: "Oberá"),
        City(id: 3, name: "Eldorado"),
        City(id: 4, name: "Puerto Iguazú"),
        City(id: 5, name: "Apóstoles"),
    ]),
    Region(id: 11, name: "Corrientes", cities: [
        City(id: 1, name: "Corrientes"),
        City(id: 2, name: "Goya"),
        City(id: 3, name: "Paso de los Libres"),
        City(id: 4, name: "Curuzú Cuatiá"),
        City(id: 5, name: "Mercedes"),
    ]),
    Region(id: 12, name: "Santiago del Estero", cities: [
        City(id: 1, name: "Santiago del Estero"),
        City(id: 2, name: "La Banda"),
        City(id: 3, name: "Termas de Río Hondo"),
        City(id: 4, name: "Frías"),
    ]),
    Region(id: 13, name: "San Juan", cities: [
        City(id: 1, name: "San Juan"),
        City(id: 2, name: "Rawson"),
        City(id: 3, name: "Chimbas"),
        City(id: 4, name: "Santa Lucía"),
    ]),
    Region(id: 14, name: "Jujuy", cities: [
        City(id: 1, name: "San Salvador de Jujuy"),
        City(id: 2, name: "San Pedro"),
        City(id: 3, name: "Palpalá"),
        City(id: 4, name: "Perico"),
    ]),
    Region(id: 15, name: "Río Negro", cities: [
        City(id: 1, name: "Viedma"),
        City(id: 2, name: "San Carlos de Bariloche"),
        City(id: 3, name: "General Roca"),
        City(id: 4, name: "Cipolletti"),
    ]),
    Region(id: 16, name: "Neuquén", cities: [
        City(id: 1, name: "Neuquén"),
        City(id: 2, name: "Cutral Có"),
        City(id: 3, name: "Centenario"),
        City(id: 4, name: "Plottier"),
    ]),
    Region(id: 17, name: "Formosa", cities: [
        City(id: 1, name: "Formosa"),
        City(id: 2, name: "Clorinda"),
        City(id: 3, name: "Pirané"),
    ]),
    Region(id: 18, name: "Chubut", cities: [
        City(id: 1, name: "Rawson"),
        City(id: 2, name: "Comodoro Rivadavia"),
        City(id: 3, name: "Trelew"),
        City(id: 4, name: "Puerto Madryn"),
    ]),
    Region(id: 19, name: "San Luis", cities: [
        City(id: 1, name: "San Luis"),
        City(id: 2, name: "Villa Mercedes"),
        City(id: 3, name: "Merlo"),
    ]),
    Region(id: 20, name: "Catamarca", cities: [
        City(id: 1, name: "San Fernando del Valle de Catamarca"),
        City(id: 2, name: "Valle Viejo"),
        City(id: 3, name: "Recreo"),
    ]),
    Region(id: 21, name: "La Rioja", cities: [
        City(id: 1, name: "La Rioja"),
        City(id: 2, name: "Chilecito"),
    ]),
    Region(id: 22, name: "La Pampa", cities: [
        City(id: 1, name: "Santa Rosa"),
        City(id: 2, name: "General Pico"),
    ]),
    Region(id: 23, name: "Santa Cruz", cities: [
        City(id: 1, name: "Río Gallegos"),
        City(id: 2, name: "Caleta Olivia"),
        City(id: 3, name: "El Calafate"),
    ]),
    Region(id: 24, name: "Tierra del Fuego", cities: [
        City(id: 1, name: "Ushuaia"),
        City(id: 2, name: "Río Grande"),
        City(id: 3, name: "Tolhuin"),
    ]),
])
