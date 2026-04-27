//
//  ArgentinaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let argentina = Country(id: 1, name: "Argentina", regions: [
    Region(id: 1, name: "Buenos Aires", cities: [
        City(id: 1, name: "La Plata", legalName: "Partido de La Plata", isCapital: false, coordinates: .init(lat: -34.92126, lng: -57.95442)),
        City(id: 2, name: "Mar del Plata", legalName: "Partido de General Pueyrredón", isCapital: false, coordinates: .init(lat: -38.00042, lng: -57.5562)),
        City(id: 3, name: "Bahía Blanca", legalName: "Partido de Bahía Blanca", isCapital: false, coordinates: .init(lat: -38.7176, lng: -62.26545)),
        City(id: 4, name: "Lanús", legalName: "Partido de Lanús", isCapital: false, coordinates: .init(lat: -34.70757, lng: -58.39132)),
        City(id: 5, name: "Quilmes", legalName: "Partido de Quilmes", isCapital: false, coordinates: .init(lat: -34.72065, lng: -58.25454)),
        City(id: 6, name: "Tandil", legalName: "Partido de Tandil", isCapital: false, coordinates: .init(lat: -37.3287, lng: -59.1369)),
        City(id: 7, name: "Pilar", legalName: "Partido de Pilar", isCapital: false, coordinates: .init(lat: -34.45867, lng: -58.91398)),
        City(id: 8, name: "San Nicolás", legalName: "Partido de San Nicolás", isCapital: false, coordinates: .init(lat: -33.33425, lng: -60.2108)),
        City(id: 9, name: "Pergamino", legalName: "Partido de Pergamino", isCapital: false, coordinates: .init(lat: -33.89101, lng: -60.57462)),
        City(id: 10, name: "Olavarría", legalName: "Partido de Olavarría", isCapital: false, coordinates: .init(lat: -36.89384, lng: -60.32319)),
    ]),
    Region(id: 2, name: "Córdoba", cities: [
        City(id: 1, name: "Córdoba", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -31.40648, lng: -64.18853)),
        City(id: 2, name: "Río Cuarto", legalName: "Departamento de Río Cuarto", isCapital: false, coordinates: .init(lat: -33.13044, lng: -64.35272)),
        City(id: 3, name: "Villa María", legalName: "Departamento de General San Martín", isCapital: false, coordinates: .init(lat: -32.40751, lng: -63.24016)),
        City(id: 4, name: "Villa Carlos Paz", legalName: "Departamento de Punilla", isCapital: false, coordinates: .init(lat: -31.4183, lng: -64.49008)),
        City(id: 5, name: "San Francisco", legalName: "Departamento de Ayacucho", isCapital: false, coordinates: .init(lat: -32.60029, lng: -66.12713)),
        City(id: 6, name: "Alta Gracia", legalName: "Departamento de Santa María", isCapital: false, coordinates: .init(lat: -31.64978, lng: -64.42972)),
        City(id: 7, name: "Río Tercero", legalName: "Departamento de Tercero Arriba", isCapital: false, coordinates: .init(lat: -32.17675, lng: -64.11295)),
    ]),
    Region(id: 3, name: "Santa Fe", cities: [
        City(id: 1, name: "Rosario", legalName: "Rosario Department", isCapital: false, coordinates: .init(lat: -32.94682, lng: -60.63932)),
        City(id: 2, name: "Santa Fe", legalName: "Departamento de La Capital", isCapital: false, coordinates: .init(lat: -31.64881, lng: -60.70868)),
        City(id: 3, name: "Rafaela", legalName: "Departamento de Castellanos", isCapital: false, coordinates: .init(lat: -31.25033, lng: -61.4867)),
        City(id: 4, name: "Venado Tuerto", legalName: "General López Department", isCapital: false, coordinates: .init(lat: -33.74556, lng: -61.96885)),
        City(id: 5, name: "Reconquista", legalName: "General Obligado Department", isCapital: false, coordinates: .init(lat: -29.15, lng: -59.65)),
        City(id: 6, name: "Santo Tomé", legalName: "Departamento de La Capital", isCapital: false, coordinates: .init(lat: -31.66274, lng: -60.7653)),
        City(id: 7, name: "Villa Constitución", legalName: "Departamento de Constitución", isCapital: false, coordinates: .init(lat: -33.22778, lng: -60.3297)),
    ]),
    Region(id: 4, name: "Ciudad Autónoma de Buenos Aires", cities: [
        City(id: 1, name: "Buenos Aires", legalName: "", isCapital: false, coordinates: .init(lat: -34.61315, lng: -58.37723)),
    ]),
    Region(id: 5, name: "Mendoza", cities: [
        City(id: 1, name: "Mendoza", legalName: "Departamento de Guaymallén", isCapital: false, coordinates: .init(lat: -32.88946, lng: -68.84582)),
        City(id: 2, name: "San Rafael", legalName: "Departamento de San Rafael", isCapital: false, coordinates: .init(lat: -34.61531, lng: -68.33238)),
        City(id: 3, name: "Godoy Cruz", legalName: "Departamento de Godoy Cruz", isCapital: false, coordinates: .init(lat: -32.92533, lng: -68.84428)),
        City(id: 4, name: "Guaymallén", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 5, name: "Las Heras", legalName: "Departamento de Deseado", isCapital: false, coordinates: .init(lat: -46.54131, lng: -68.93227)),
        City(id: 6, name: "Luján de Cuyo", legalName: "Departamento de Luján", isCapital: false, coordinates: .init(lat: -33.03917, lng: -68.87955)),
    ]),
    Region(id: 6, name: "Tucumán", cities: [
        City(id: 1, name: "San Miguel de Tucumán", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -26.81601, lng: -65.21051)),
        City(id: 2, name: "Yerba Buena", legalName: "Departamento de Yerba Buena", isCapital: false, coordinates: .init(lat: -26.81298, lng: -65.29543)),
        City(id: 3, name: "Tafí Viejo", legalName: "Departamento de Tafí Viejo", isCapital: false, coordinates: .init(lat: -26.7333, lng: -65.26146)),
        City(id: 4, name: "Concepción", legalName: "Departamento de San Justo", isCapital: false, coordinates: .init(lat: -31.32212, lng: -62.81399)),
        City(id: 5, name: "Alderetes", legalName: "Departamento de Cruz Alta", isCapital: false, coordinates: .init(lat: -26.81787, lng: -65.14202)),
    ]),
    Region(id: 7, name: "Entre Ríos", cities: [
        City(id: 1, name: "Paraná", legalName: "Departamento de Islas del Ibicuy", isCapital: false, coordinates: .init(lat: -33.71381, lng: -58.65844)),
        City(id: 2, name: "Concordia", legalName: "Departamento de Concordia", isCapital: false, coordinates: .init(lat: -31.39195, lng: -58.01706)),
        City(id: 3, name: "Gualeguaychú", legalName: "Departamento de Gualeguaychú", isCapital: false, coordinates: .init(lat: -33.00777, lng: -58.51836)),
        City(id: 4, name: "Concepción del Uruguay", legalName: "Departamento de Uruguay", isCapital: false, coordinates: .init(lat: -32.48463, lng: -58.23217)),
        City(id: 5, name: "Gualeguay", legalName: "Departamento de Gualeguay", isCapital: false, coordinates: .init(lat: -33.14091, lng: -59.31257)),
    ]),
    Region(id: 8, name: "Salta", cities: [
        City(id: 1, name: "Salta", legalName: "Departamento Capital", isCapital: false, coordinates: .init(lat: -24.80645, lng: -65.41999)),
        City(id: 2, name: "San Ramón de la Nueva Orán", legalName: "Departamento de Orán", isCapital: false, coordinates: .init(lat: -23.13705, lng: -64.32426)),
        City(id: 3, name: "Tartagal", legalName: "Departamento de General José de San Martín", isCapital: false, coordinates: .init(lat: -22.51682, lng: -63.8056)),
        City(id: 4, name: "General Güemes", legalName: "Departamento de General Güemes", isCapital: false, coordinates: .init(lat: -24.67445, lng: -65.0466)),
        City(id: 5, name: "Rosario de Lerma", legalName: "Departamento de Rosario de Lerma", isCapital: false, coordinates: .init(lat: -24.98583, lng: -65.5784)),
    ]),
    Region(id: 9, name: "Chaco", cities: [
        City(id: 1, name: "Resistencia", legalName: "Departamento de San Fernando", isCapital: false, coordinates: .init(lat: -27.46363, lng: -58.98665)),
        City(id: 2, name: "Presidencia Roque Sáenz Peña", legalName: "Departamento de Comandante Fernández", isCapital: false, coordinates: .init(lat: -26.79095, lng: -60.44132)),
        City(id: 3, name: "Villa Ángela", legalName: "Departamento de Mayor Luis J. Fontana", isCapital: false, coordinates: .init(lat: -27.57679, lng: -60.71114)),
        City(id: 4, name: "Charata", legalName: "Chacabuco", isCapital: false, coordinates: .init(lat: -27.21787, lng: -61.18738)),
        City(id: 5, name: "Juan José Castelli", legalName: "Departamento de General Güemes", isCapital: false, coordinates: .init(lat: -25.9466, lng: -60.62008)),
    ]),
    Region(id: 10, name: "Misiones", cities: [
        City(id: 1, name: "Posadas", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -27.39184, lng: -55.92379)),
        City(id: 2, name: "Oberá", legalName: "Departamento de Oberá", isCapital: false, coordinates: .init(lat: -27.48683, lng: -55.11994)),
        City(id: 3, name: "Eldorado", legalName: "Departamento de Eldorado", isCapital: false, coordinates: .init(lat: -26.40453, lng: -54.61847)),
        City(id: 4, name: "Puerto Iguazú", legalName: "Departamento de Iguazú", isCapital: false, coordinates: .init(lat: -25.59912, lng: -54.57355)),
        City(id: 5, name: "Apóstoles", legalName: "Departamento de Apóstoles", isCapital: false, coordinates: .init(lat: -27.91421, lng: -55.75355)),
    ]),
    Region(id: 11, name: "Corrientes", cities: [
        City(id: 1, name: "Corrientes", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -27.46784, lng: -58.8344)),
        City(id: 2, name: "Goya", legalName: "Departamento de Nogoyá", isCapital: false, coordinates: .init(lat: -32.39375, lng: -59.78955)),
        City(id: 3, name: "Paso de los Libres", legalName: "Departamento de Paso de los Libres", isCapital: false, coordinates: .init(lat: -29.71251, lng: -57.08771)),
        City(id: 4, name: "Curuzú Cuatiá", legalName: "Departamento de Curuzú Cuatiá", isCapital: false, coordinates: .init(lat: -29.79145, lng: -58.0499)),
        City(id: 5, name: "Mercedes", legalName: "Departamento de General Pedernera", isCapital: false, coordinates: .init(lat: -33.67571, lng: -65.45783)),
    ]),
    Region(id: 12, name: "Santiago del Estero", cities: [
        City(id: 1, name: "Santiago del Estero", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -27.80047, lng: -64.26285)),
        City(id: 2, name: "La Banda", legalName: "Departamento de Banda", isCapital: false, coordinates: .init(lat: -27.73044, lng: -64.24383)),
        City(id: 3, name: "Termas de Río Hondo", legalName: "Departamento de Río Hondo", isCapital: false, coordinates: .init(lat: -27.49362, lng: -64.85972)),
        City(id: 4, name: "Frías", legalName: "Departamento de Choya", isCapital: false, coordinates: .init(lat: -28.63754, lng: -65.12873)),
    ]),
    Region(id: 13, name: "San Juan", cities: [
        City(id: 1, name: "San Juan", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -31.53726, lng: -68.52568)),
        City(id: 2, name: "Rawson", legalName: "Departamento de Rawson", isCapital: false, coordinates: .init(lat: -43.30031, lng: -65.10564)),
        City(id: 3, name: "Chimbas", legalName: "Departamento de Chimbas", isCapital: false, coordinates: .init(lat: -31.49313, lng: -68.53263)),
        City(id: 4, name: "Santa Lucía", legalName: "Departamento de Santa Lucía", isCapital: false, coordinates: .init(lat: -31.54055, lng: -68.49794)),
    ]),
    Region(id: 14, name: "Jujuy", cities: [
        City(id: 1, name: "San Salvador de Jujuy", legalName: "Departamento de Doctor Manuel Belgrano", isCapital: false, coordinates: .init(lat: -24.1928, lng: -65.29342)),
        City(id: 2, name: "San Pedro", legalName: "Partido de San Pedro", isCapital: false, coordinates: .init(lat: -33.67918, lng: -59.66633)),
        City(id: 3, name: "Palpalá", legalName: "Departamento de Palpalá", isCapital: false, coordinates: .init(lat: -24.25798, lng: -65.21358)),
        City(id: 4, name: "Perico", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
    ]),
    Region(id: 15, name: "Río Negro", cities: [
        City(id: 1, name: "Viedma", legalName: "Departamento de Adolfo Alsina", isCapital: false, coordinates: .init(lat: -40.81519, lng: -63.0004)),
        City(id: 2, name: "San Carlos de Bariloche", legalName: "Departamento de Bariloche", isCapital: false, coordinates: .init(lat: -41.14557, lng: -71.30822)),
        City(id: 3, name: "General Roca", legalName: "Departamento de General Roca", isCapital: false, coordinates: .init(lat: -39.03333, lng: -67.58333)),
        City(id: 4, name: "Cipolletti", legalName: "Departamento de General Roca", isCapital: false, coordinates: .init(lat: -38.93392, lng: -67.99032)),
    ]),
    Region(id: 16, name: "Neuquén", cities: [
        City(id: 1, name: "Neuquén", legalName: "Departamento de Confluencia", isCapital: false, coordinates: .init(lat: -38.95078, lng: -68.0592)),
        City(id: 2, name: "Cutral Có", legalName: "Departamento de Confluencia", isCapital: false, coordinates: .init(lat: -38.93424, lng: -69.23052)),
        City(id: 3, name: "Centenario", legalName: "Departamento de Confluencia", isCapital: false, coordinates: .init(lat: -38.82955, lng: -68.1318)),
        City(id: 4, name: "Plottier", legalName: "Departamento de Confluencia", isCapital: false, coordinates: .init(lat: -38.96667, lng: -68.23333)),
    ]),
    Region(id: 17, name: "Formosa", cities: [
        City(id: 1, name: "Formosa", legalName: "Departamento de Formosa", isCapital: false, coordinates: .init(lat: -26.18489, lng: -58.17313)),
        City(id: 2, name: "Clorinda", legalName: "Departamento de Pilcomayo", isCapital: false, coordinates: .init(lat: -25.28627, lng: -57.72168)),
        City(id: 3, name: "Pirané", legalName: "Departamento de Pirané", isCapital: false, coordinates: .init(lat: -25.73271, lng: -59.10989)),
    ]),
    Region(id: 18, name: "Chubut", cities: [
        City(id: 1, name: "Rawson", legalName: "Departamento de Rawson", isCapital: false, coordinates: .init(lat: -43.30031, lng: -65.10564)),
        City(id: 2, name: "Comodoro Rivadavia", legalName: "Departamento de Escalante", isCapital: false, coordinates: .init(lat: -45.86256, lng: -67.494)),
        City(id: 3, name: "Trelew", legalName: "Departamento de Rawson", isCapital: false, coordinates: .init(lat: -43.24895, lng: -65.30505)),
        City(id: 4, name: "Puerto Madryn", legalName: "Departamento de Biedma", isCapital: false, coordinates: .init(lat: -42.76848, lng: -65.03827)),
    ]),
    Region(id: 19, name: "San Luis", cities: [
        City(id: 1, name: "San Luis", legalName: "Departamento de San Luis del Palmar", isCapital: false, coordinates: .init(lat: -27.50766, lng: -58.55625)),
        City(id: 2, name: "Villa Mercedes", legalName: "Departamento de General Pedernera", isCapital: false, coordinates: .init(lat: -33.67571, lng: -65.45783)),
        City(id: 3, name: "Merlo", legalName: "Departamento de Junín", isCapital: false, coordinates: .init(lat: -32.34288, lng: -65.01396)),
    ]),
    Region(id: 20, name: "Catamarca", cities: [
        City(id: 1, name: "San Fernando del Valle de Catamarca", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Valle Viejo", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Recreo", legalName: "Departamento de La Paz", isCapital: false, coordinates: .init(lat: -29.28184, lng: -65.06096)),
    ]),
    Region(id: 21, name: "La Rioja", cities: [
        City(id: 1, name: "La Rioja", legalName: "Departamento de Capital", isCapital: false, coordinates: .init(lat: -29.41328, lng: -66.85637)),
        City(id: 2, name: "Chilecito", legalName: "Departamento de Chilecito", isCapital: false, coordinates: .init(lat: -29.16195, lng: -67.4974)),
    ]),
    Region(id: 22, name: "La Pampa", cities: [
        City(id: 1, name: "Santa Rosa", legalName: "Departamento de Santa Rosa", isCapital: false, coordinates: .init(lat: -33.25407, lng: -68.15066)),
        City(id: 2, name: "General Pico", legalName: "Departamento de Maracó", isCapital: false, coordinates: .init(lat: -35.6593, lng: -63.75787)),
    ]),
    Region(id: 23, name: "Santa Cruz", cities: [
        City(id: 1, name: "Río Gallegos", legalName: "Departamento de Güer Aike", isCapital: false, coordinates: .init(lat: -51.6253, lng: -69.25229)),
        City(id: 2, name: "Caleta Olivia", legalName: "Departamento de Deseado", isCapital: false, coordinates: .init(lat: -46.44785, lng: -67.52274)),
        City(id: 3, name: "El Calafate", legalName: "Departamento de Lago Argentino", isCapital: false, coordinates: .init(lat: -50.34075, lng: -72.27682)),
    ]),
    Region(id: 24, name: "Tierra del Fuego", cities: [
        City(id: 1, name: "Ushuaia", legalName: "Departamento de Ushuaia", isCapital: false, coordinates: .init(lat: -54.81084, lng: -68.31591)),
        City(id: 2, name: "Río Grande", legalName: "Departamento de Río Grande", isCapital: false, coordinates: .init(lat: -53.78773, lng: -67.70975)),
        City(id: 3, name: "Tolhuin", legalName: "", isCapital: false, coordinates: .init(lat: -54.51083, lng: -67.1955)),
    ]),
])
