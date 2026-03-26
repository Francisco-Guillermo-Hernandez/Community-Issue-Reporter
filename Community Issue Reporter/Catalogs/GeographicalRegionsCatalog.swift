//
//  GeographicalRegionsCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/3/26.
//

import Foundation

let geographicalRegions: [GeographicalRegion] = [
    GeographicalRegion(id: 1, name: "North America", countries: [
        canada,
        unitedStates,
        mexico,
        belize
    ]),
    
    GeographicalRegion(id: 2, name: "Central America", countries: [
        guatemala,
        elSalvador,
        honduras,
        nicaragua,
        costaRica,
        panama
    ]),
    
    GeographicalRegion(id: 3, name: "Antilles", countries: [
        antiguaAndBarbuda,
        bahamas,
        barbados,
        cuba,
        dominica,
        dominicanRepublic,
        grenada,
        haiti,
        jamaica,
        saintKittsAndNevis,
        saintLucia,
        saintVincentAndTheGrenadines,
        trinidadAndTobago
    ]),
    
    GeographicalRegion(id: 4, name: "South America", countries: [
        argentina,
        bolivia,
        brazil,
        chile,
        colombia,
        ecuador,
        guyana,
        paraguay,
        peru,
        suriname,
        uruguay,
        venezuela
    ]),
    
    GeographicalRegion(id: 5, name: "Europe", countries: [
        france,
        germany,
        italy,
        spain
    ]),
]
