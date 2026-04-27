//
//  PeruCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let peru = Country(id: 9, name: "Peru", regions: [
    Region(id: 1, name: "Lima", cities: [
        City(id: 1, name: "Lima", legalName: "", isCapital: false, coordinates: .init(lat: -12.04318, lng: -77.02824)),
        City(id: 2, name: "Huacho", legalName: "Huaura", isCapital: false, coordinates: .init(lat: -11.10667, lng: -77.605)),
        City(id: 3, name: "Huaral", legalName: "Provincia de Huaral", isCapital: false, coordinates: .init(lat: -11.495, lng: -77.20778)),
        City(id: 4, name: "Cañete", legalName: "Provincia de Cañete", isCapital: false, coordinates: .init(lat: -13.07556, lng: -76.38528)),
    ]),
    Region(id: 2, name: "Piura", cities: [
        City(id: 1, name: "Piura", legalName: "Provincia de Piura", isCapital: false, coordinates: .init(lat: -5.19449, lng: -80.63282)),
        City(id: 2, name: "Sullana", legalName: "Provincia de Sullana", isCapital: false, coordinates: .init(lat: -4.90389, lng: -80.68528)),
        City(id: 3, name: "Paita", legalName: "Provincia de Paita", isCapital: false, coordinates: .init(lat: -5.08917, lng: -81.11444)),
        City(id: 4, name: "Talara", legalName: "Provincia de Talara", isCapital: false, coordinates: .init(lat: -4.57722, lng: -81.27194)),
    ]),
    Region(id: 3, name: "La Libertad", cities: [
        City(id: 1, name: "Trujillo", legalName: "Provincia de Trujillo", isCapital: false, coordinates: .init(lat: -8.11599, lng: -79.02998)),
        City(id: 2, name: "Huamachuco", legalName: "Sanchez Carrion", isCapital: false, coordinates: .init(lat: -7.8, lng: -78.06667)),
        City(id: 3, name: "Pacasmayo", legalName: "Provincia de Pacasmayo", isCapital: false, coordinates: .init(lat: -7.40056, lng: -79.57139)),
    ]),
    Region(id: 4, name: "Arequipa", cities: [
        City(id: 1, name: "Arequipa", legalName: "Provincia de Arequipa", isCapital: false, coordinates: .init(lat: -16.39889, lng: -71.535)),
        City(id: 2, name: "Mollendo", legalName: "Provincia de Islay", isCapital: false, coordinates: .init(lat: -17.02306, lng: -72.01472)),
        City(id: 3, name: "Camaná", legalName: "Provincia de Camaná", isCapital: false, coordinates: .init(lat: -16.62375, lng: -72.71055)),
    ]),
    Region(id: 5, name: "Cajamarca", cities: [
        City(id: 1, name: "Cajamarca", legalName: "Provincia de Cajamarca", isCapital: false, coordinates: .init(lat: -7.16378, lng: -78.50027)),
        City(id: 2, name: "Jaén", legalName: "Provincia de Jaén", isCapital: false, coordinates: .init(lat: -5.70729, lng: -78.80785)),
        City(id: 3, name: "Chota", legalName: "Provincia de Chota", isCapital: false, coordinates: .init(lat: -6.55, lng: -78.65)),
    ]),
    Region(id: 6, name: "Junín", cities: [
        City(id: 1, name: "Huancayo", legalName: "Provincia de Huancayo", isCapital: false, coordinates: .init(lat: -12.06513, lng: -75.20486)),
        City(id: 2, name: "Tarma", legalName: "Provincia de Tarma", isCapital: false, coordinates: .init(lat: -11.41899, lng: -75.68992)),
        City(id: 3, name: "Jauja", legalName: "Provincia de Jauja", isCapital: false, coordinates: .init(lat: -11.77584, lng: -75.49656)),
        City(id: 4, name: "Satipo", legalName: "Provincia de Satipo", isCapital: false, coordinates: .init(lat: -11.25222, lng: -74.63861)),
    ]),
    Region(id: 7, name: "Cusco", cities: [
        City(id: 1, name: "Cusco", legalName: "Provincia de Cusco", isCapital: false, coordinates: .init(lat: -13.52264, lng: -71.96734)),
        City(id: 2, name: "Quillabamba", legalName: "Provincia de La Convención", isCapital: false, coordinates: .init(lat: -12.86334, lng: -72.69306)),
        City(id: 3, name: "Sicuani", legalName: "Provincia de Canchis", isCapital: false, coordinates: .init(lat: -14.26944, lng: -71.22611)),
    ]),
    Region(id: 8, name: "Lambayeque", cities: [
        City(id: 1, name: "Chiclayo", legalName: "Provincia de Chiclayo", isCapital: false, coordinates: .init(lat: -6.77137, lng: -79.84088)),
        City(id: 2, name: "Lambayeque", legalName: "Provincia de Lambayeque", isCapital: false, coordinates: .init(lat: -6.70111, lng: -79.90611)),
        City(id: 3, name: "Ferreñafe", legalName: "Provincia de Ferreñafe", isCapital: false, coordinates: .init(lat: -6.63889, lng: -79.78889)),
    ]),
    Region(id: 9, name: "Puno", cities: [
        City(id: 1, name: "Puno", legalName: "Provincia de Huamalíes", isCapital: false, coordinates: .init(lat: -9.49735, lng: -76.88469)),
        City(id: 2, name: "Juliaca", legalName: "Provincia de San Román", isCapital: false, coordinates: .init(lat: -15.5, lng: -70.13333)),
    ]),
    Region(id: 10, name: "Ancash", cities: [
        City(id: 1, name: "Huaraz", legalName: "Provincia de Huaraz", isCapital: false, coordinates: .init(lat: -9.52779, lng: -77.52778)),
        City(id: 2, name: "Chimbote", legalName: "Provincia de Santa", isCapital: false, coordinates: .init(lat: -9.07508, lng: -78.59373)),
    ]),
    Region(id: 11, name: "Loreto", cities: [
        City(id: 1, name: "Iquitos", legalName: "Provincia de Maynas", isCapital: false, coordinates: .init(lat: -3.74912, lng: -73.25383)),
        City(id: 2, name: "Yurimaguas", legalName: "Provincia de Alto Amazonas", isCapital: false, coordinates: .init(lat: -5.90181, lng: -76.12234)),
    ]),
    Region(id: 12, name: "Ica", cities: [
        City(id: 1, name: "Ica", legalName: "Provincia de Sullana", isCapital: false, coordinates: .init(lat: -4.87778, lng: -80.70528)),
        City(id: 2, name: "Chincha Alta", legalName: "Provincia de Chincha", isCapital: false, coordinates: .init(lat: -13.40985, lng: -76.13235)),
        City(id: 3, name: "Pisco", legalName: "Provincia de Pisco", isCapital: false, coordinates: .init(lat: -13.71029, lng: -76.20538)),
        City(id: 4, name: "Nasca", legalName: "Provincia de Mariscal Luzuriaga", isCapital: false, coordinates: .init(lat: -8.85542, lng: -77.39825)),
    ]),
    Region(id: 13, name: "San Martín", cities: [
        City(id: 1, name: "Tarapoto", legalName: "Provincia de San Martín", isCapital: false, coordinates: .init(lat: -6.50139, lng: -76.36556)),
        City(id: 2, name: "Moyobamba", legalName: "Provincia de Moyobamba", isCapital: false, coordinates: .init(lat: -6.03416, lng: -76.97168)),
    ]),
    Region(id: 14, name: "Huánuco", cities: [
        City(id: 1, name: "Huánuco", legalName: "Provincia de Huánuco", isCapital: false, coordinates: .init(lat: -9.93062, lng: -76.24223)),
        City(id: 2, name: "Tingo María", legalName: "Provincia de Leoncio Prado", isCapital: false, coordinates: .init(lat: -9.29532, lng: -75.99574)),
    ]),
    Region(id: 15, name: "Ayacucho", cities: [
        City(id: 1, name: "Ayacucho", legalName: "Provincia de Huamanga", isCapital: false, coordinates: .init(lat: -13.15878, lng: -74.22321)),
    ]),
    Region(id: 16, name: "Ucayali", cities: [
        City(id: 1, name: "Pucallpa", legalName: "Provincia de Coronel Portillo", isCapital: false, coordinates: .init(lat: -8.37915, lng: -74.55387)),
    ]),
    Region(id: 17, name: "Apurímac", cities: [
        City(id: 1, name: "Abancay", legalName: "Provincia de Abancay", isCapital: false, coordinates: .init(lat: -13.63389, lng: -72.88139)),
        City(id: 2, name: "Andahuaylas", legalName: "Provincia de Andahuaylas", isCapital: false, coordinates: .init(lat: -13.65556, lng: -73.38722)),
    ]),
    Region(id: 18, name: "Amazonas", cities: [
        City(id: 1, name: "Chachapoyas", legalName: "Provincia de Chachapoyas", isCapital: false, coordinates: .init(lat: -6.23169, lng: -77.86903)),
        City(id: 2, name: "Bagua Grande", legalName: "Utcubamba", isCapital: false, coordinates: .init(lat: -5.75611, lng: -78.44111)),
    ]),
    Region(id: 19, name: "Huancavelica", cities: [
        City(id: 1, name: "Huancavelica", legalName: "Provincia de Huancavelica", isCapital: false, coordinates: .init(lat: -12.78261, lng: -74.97266)),
    ]),
    Region(id: 20, name: "Tacna", cities: [
        City(id: 1, name: "Tacna", legalName: "Provincia de Tacna", isCapital: false, coordinates: .init(lat: -18.01465, lng: -70.25362)),
    ]),
    Region(id: 21, name: "Pasco", cities: [
        City(id: 1, name: "Cerro de Pasco", legalName: "Provincia de Pasco", isCapital: false, coordinates: .init(lat: -10.66748, lng: -76.25668)),
    ]),
    Region(id: 22, name: "Tumbes", cities: [
        City(id: 1, name: "Tumbes", legalName: "Provincia de Tumbes", isCapital: false, coordinates: .init(lat: -3.56694, lng: -80.45153)),
    ]),
    Region(id: 23, name: "Moquegua", cities: [
        City(id: 1, name: "Moquegua", legalName: "Provincia de Mariscal Nieto", isCapital: false, coordinates: .init(lat: -17.19832, lng: -70.93567)),
        City(id: 2, name: "Ilo", legalName: "Provincia de Ilo", isCapital: false, coordinates: .init(lat: -17.63185, lng: -71.34108)),
    ]),
    Region(id: 24, name: "Madre de Dios", cities: [
        City(id: 1, name: "Puerto Maldonado", legalName: "Provincia de Tambopata", isCapital: false, coordinates: .init(lat: -12.59331, lng: -69.18913)),
    ]),
    Region(id: 25, name: "Provincia Constitucional del Callao", cities: [
        City(id: 1, name: "Callao", legalName: "", isCapital: false, coordinates: .init(lat: -12.05659, lng: -77.11814)),
    ]),
])
