//
//  EcuadorCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let ecuador = Country(id: 6, name: "Ecuador", regions: [
    Region(id: 1, name: "Guayas", cities: [
        City(id: 1, name: "Guayaquil", legalName: "", isCapital: false, coordinates: .init(lat: -2.19616, lng: -79.88621)),
        City(id: 2, name: "Durán", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Milagro", legalName: "Atahualpa", isCapital: false, coordinates: .init(lat: -3.628, lng: -79.66126)),
        City(id: 4, name: "Samborondón", legalName: "Cantón Samborondón", isCapital: false, coordinates: .init(lat: -1.96071, lng: -79.72566)),
        City(id: 5, name: "Daule", legalName: "", isCapital: false, coordinates: .init(lat: -1.86032, lng: -79.97683)),
    ]),
    Region(id: 2, name: "Pichincha", cities: [
        City(id: 1, name: "Quito", legalName: "", isCapital: false, coordinates: .init(lat: 0.12123, lng: -79.25399)),
        City(id: 2, name: "Sangolquí", legalName: "Cantón Rumiñahui", isCapital: false, coordinates: .init(lat: -0.33405, lng: -78.45217)),
        City(id: 3, name: "Machachi", legalName: "Cantón Mejía", isCapital: false, coordinates: .init(lat: -0.51273, lng: -78.57066)),
        City(id: 4, name: "Cayambe", legalName: "", isCapital: false, coordinates: .init(lat: 0.04103, lng: -78.14636)),
    ]),
    Region(id: 3, name: "Manabí", cities: [
        City(id: 1, name: "Portoviejo", legalName: "", isCapital: false, coordinates: .init(lat: -1.05458, lng: -80.45445)),
        City(id: 2, name: "Manta", legalName: "", isCapital: false, coordinates: .init(lat: -0.94937, lng: -80.73137)),
        City(id: 3, name: "Chone", legalName: "", isCapital: false, coordinates: .init(lat: -0.6985, lng: -80.0925)),
        City(id: 4, name: "Montecristi", legalName: "", isCapital: false, coordinates: .init(lat: -1.04576, lng: -80.65889)),
        City(id: 5, name: "Jipijapa", legalName: "", isCapital: false, coordinates: .init(lat: -1.34841, lng: -80.57913)),
    ]),
    Region(id: 4, name: "Azuay", cities: [
        City(id: 1, name: "Cuenca", legalName: "", isCapital: false, coordinates: .init(lat: -2.90055, lng: -79.00453)),
        City(id: 2, name: "Gualaceo", legalName: "", isCapital: false, coordinates: .init(lat: -2.89418, lng: -78.77907)),
        City(id: 3, name: "Paute", legalName: "", isCapital: false, coordinates: .init(lat: -2.77957, lng: -78.76155)),
    ]),
    Region(id: 5, name: "Los Ríos", cities: [
        City(id: 1, name: "Quevedo", legalName: "", isCapital: false, coordinates: .init(lat: -1.02881, lng: -79.46264)),
        City(id: 2, name: "Babahoyo", legalName: "", isCapital: false, coordinates: .init(lat: -1.80217, lng: -79.53443)),
        City(id: 3, name: "Ventanas", legalName: "", isCapital: false, coordinates: .init(lat: -1.44285, lng: -79.46274)),
        City(id: 4, name: "Buena Fe", legalName: "Buena Fe", isCapital: false, coordinates: .init(lat: -0.89409, lng: -79.48985)),
    ]),
    Region(id: 6, name: "El Oro", cities: [
        City(id: 1, name: "Machala", legalName: "", isCapital: false, coordinates: .init(lat: -3.25861, lng: -79.96053)),
        City(id: 2, name: "Pasaje", legalName: "", isCapital: false, coordinates: .init(lat: -3.32561, lng: -79.80697)),
        City(id: 3, name: "Santa Rosa", legalName: "Cantón Santa Rosa", isCapital: false, coordinates: .init(lat: -3.45571, lng: -79.9637)),
        City(id: 4, name: "Huaquillas", legalName: "", isCapital: false, coordinates: .init(lat: -3.47523, lng: -80.23084)),
    ]),
    Region(id: 7, name: "Tungurahua", cities: [
        City(id: 1, name: "Ambato", legalName: "", isCapital: false, coordinates: .init(lat: -1.24908, lng: -78.61675)),
        City(id: 2, name: "Baños de Agua Santa", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Pelileo", legalName: "San Pedro de Pelileo", isCapital: false, coordinates: .init(lat: -1.33057, lng: -78.54523)),
    ]),
    Region(id: 8, name: "Loja", cities: [
        City(id: 1, name: "Loja", legalName: "", isCapital: false, coordinates: .init(lat: -3.99313, lng: -79.20422)),
        City(id: 2, name: "Catamayo", legalName: "", isCapital: false, coordinates: .init(lat: -3.98661, lng: -79.35763)),
        City(id: 3, name: "Cariamanga", legalName: "Calvas", isCapital: false, coordinates: .init(lat: -4.32804, lng: -79.55575)),
    ]),
    Region(id: 9, name: "Chimborazo", cities: [
        City(id: 1, name: "Riobamba", legalName: "", isCapital: false, coordinates: .init(lat: -1.67098, lng: -78.64712)),
        City(id: 2, name: "Guano", legalName: "", isCapital: false, coordinates: .init(lat: -1.60689, lng: -78.63726)),
    ]),
    Region(id: 10, name: "Imbabura", cities: [
        City(id: 1, name: "Ibarra", legalName: "", isCapital: false, coordinates: .init(lat: 0.35171, lng: -78.12233)),
        City(id: 2, name: "Otavalo", legalName: "", isCapital: false, coordinates: .init(lat: 0.23457, lng: -78.26248)),
        City(id: 3, name: "Cotacachi", legalName: "", isCapital: false, coordinates: .init(lat: 0.29947, lng: -78.26565)),
    ]),
    Region(id: 11, name: "Santo Domingo de los Tsáchilas", cities: [
        City(id: 1, name: "Santo Domingo", legalName: "Santo Domingo", isCapital: false, coordinates: .init(lat: -0.25305, lng: -79.17536)),
    ]),
    Region(id: 12, name: "Santa Elena", cities: [
        City(id: 1, name: "Santa Elena", legalName: "", isCapital: false, coordinates: .init(lat: -2.22622, lng: -80.85873)),
        City(id: 2, name: "La Libertad", legalName: "", isCapital: false, coordinates: .init(lat: -2.233, lng: -80.91039)),
        City(id: 3, name: "Salinas", legalName: "", isCapital: false, coordinates: .init(lat: -2.21452, lng: -80.95151)),
    ]),
    Region(id: 13, name: "Esmeraldas", cities: [
        City(id: 1, name: "Esmeraldas", legalName: "", isCapital: false, coordinates: .init(lat: 0.9592, lng: -79.65397)),
        City(id: 2, name: "Quinindé", legalName: "", isCapital: false, coordinates: .init(lat: 0, lng: 0)),
        City(id: 3, name: "Atacames", legalName: "", isCapital: false, coordinates: .init(lat: 0.86903, lng: -79.84806)),
    ]),
    Region(id: 14, name: "Cotopaxi", cities: [
        City(id: 1, name: "Latacunga", legalName: "", isCapital: false, coordinates: .init(lat: -0.93521, lng: -78.61554)),
        City(id: 2, name: "Pujilí", legalName: "Cantón Pujilí", isCapital: false, coordinates: .init(lat: -0.95759, lng: -78.69636)),
        City(id: 3, name: "La Maná", legalName: "", isCapital: false, coordinates: .init(lat: -0.94096, lng: -79.22655)),
    ]),
    Region(id: 15, name: "Carchi", cities: [
        City(id: 1, name: "Tulcán", legalName: "Cantón Tulcán", isCapital: false, coordinates: .init(lat: 0.81187, lng: -77.71727)),
    ]),
    Region(id: 16, name: "Bolívar", cities: [
        City(id: 1, name: "Guaranda", legalName: "", isCapital: false, coordinates: .init(lat: -1.59263, lng: -79.00098)),
    ]),
    Region(id: 17, name: "Cañar", cities: [
        City(id: 1, name: "Azogues", legalName: "", isCapital: false, coordinates: .init(lat: -2.73969, lng: -78.8486)),
        City(id: 2, name: "La Troncal", legalName: "", isCapital: false, coordinates: .init(lat: -2.42466, lng: -79.34159)),
    ]),
    Region(id: 18, name: "Morona Santiago", cities: [
        City(id: 1, name: "Macas", legalName: "Morona", isCapital: false, coordinates: .init(lat: -2.30868, lng: -78.11135)),
    ]),
    Region(id: 19, name: "Napo", cities: [
        City(id: 1, name: "Tena", legalName: "", isCapital: false, coordinates: .init(lat: -0.9938, lng: -77.81286)),
    ]),
    Region(id: 20, name: "Pastaza", cities: [
        City(id: 1, name: "Puyo", legalName: "Pastaza", isCapital: false, coordinates: .init(lat: -1.48369, lng: -78.00257)),
    ]),
    Region(id: 21, name: "Orellana", cities: [
        City(id: 1, name: "Puerto Francisco de Orellana", legalName: "Francisco de Orellana Canton", isCapital: false, coordinates: .init(lat: -0.46645, lng: -76.98719)),
    ]),
    Region(id: 22, name: "Sucumbíos", cities: [
        City(id: 1, name: "Nueva Loja", legalName: "Lago Agrio", isCapital: false, coordinates: .init(lat: 0.086, lng: -76.89528)),
    ]),
    Region(id: 23, name: "Zamora Chinchipe", cities: [
        City(id: 1, name: "Zamora", legalName: "", isCapital: false, coordinates: .init(lat: -4.06685, lng: -78.95488)),
    ]),
    Region(id: 24, name: "Galápagos", cities: [
        City(id: 1, name: "Puerto Baquerizo Moreno", legalName: "Cantón San Cristóbal", isCapital: false, coordinates: .init(lat: -0.90172, lng: -89.61021)),
        City(id: 2, name: "Puerto Ayora", legalName: "Santa Cruz", isCapital: false, coordinates: .init(lat: -0.74018, lng: -90.3138)),
    ]),
])
