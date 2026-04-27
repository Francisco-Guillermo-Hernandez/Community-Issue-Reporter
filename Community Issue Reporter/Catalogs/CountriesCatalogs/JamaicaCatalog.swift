//
//  JamaicaCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/3/26.
//

import Foundation

let jamaica = Country(id: 9, name: "Jamaica", regions: [
    Region(id: 1, name: "Kingston", cities: [
        City(id: 1, name: "Kingston", legalName: "", coordinates: .init(lat: 17.99702, lng: -76.79358)),
    ]),
    Region(id: 2, name: "Saint Andrew", cities: [
        City(id: 1, name: "Half Way Tree", legalName: "Half-Way-Tree", coordinates: .init(lat: 18.01248, lng: -76.79928)),
        City(id: 2, name: "Portmore", legalName: "Naggo Head", coordinates: .init(lat: 17.97102, lng: -76.88691)),
    ]),
    Region(id: 3, name: "Saint Catherine", cities: [
        City(id: 1, name: "Spanish Town", legalName: "Spanish Town Central", coordinates: .init(lat: 17.99107, lng: -76.95742)),
        City(id: 2, name: "Linstead", legalName: "", coordinates: .init(lat: 18.13683, lng: -77.03171)),
        City(id: 3, name: "Old Harbour",legalName: "", coordinates: .init(lat: 17.90918, lng: -77.09718)),
    ]),
    Region(id: 4, name: "Saint James", cities: [
        City(id: 1, name: "Montego Bay", legalName: "Down Town Montego Bay", coordinates: .init(lat: 18.47116, lng: -77.91883)),
    ]),
    Region(id: 5, name: "Clarendon", cities: [
        City(id: 1, name: "May Pen", legalName: "May Pen Proper", coordinates: .init(lat: 17.96454, lng: -77.24515)),
    ]),
    Region(id: 6, name: "Manchester", cities: [
        City(id: 1, name: "Mandeville",legalName: "Mandeville Proper", coordinates: .init(lat: 18.04168, lng: -77.50714)),
    ]),
    Region(id: 7, name: "Saint Ann", cities: [
        City(id: 1, name: "Saint Ann's Bay", legalName: "", coordinates: .init(lat: 0, lng: 0)),
        City(id: 2, name: "Ocho Rios", legalName: "", coordinates: .init(lat: 18.4076, lng: -77.10312)),
    ]),
    Region(id: 8, name: "Saint Elizabeth", cities: [
        City(id: 1, name: "Black River",legalName: "", coordinates: .init(lat: 18.02636, lng: -77.84873)),
        City(id: 2, name: "Santa Cruz",legalName: "", coordinates: .init(lat: 18.05336, lng: -77.69836)),
    ]),
    Region(id: 9, name: "Westmoreland", cities: [
        City(id: 1, name: "Savanna-la-Mar",legalName: "Savanna-la-mar Business Dist.", coordinates: .init(lat: 18.21895, lng: -78.1332)),
        City(id: 2, name: "Negril",legalName: "", coordinates: .init(lat: 18.26844, lng: -78.3481)),
    ]),
    Region(id: 10, name: "Portland", cities: [
        City(id: 1, name: "Port Antonio",legalName: "Central Port Antonio", coordinates: .init(lat: 18.17889, lng: -76.45215)),
    ]),
])
