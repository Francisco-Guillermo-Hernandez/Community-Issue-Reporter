//
//  MatterToSolveCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation

let mattersToResolve: [MatterToSolve] = [
    MatterToSolve(
        id: 1,
        title: String(
            localized: "Potholes"
        ),
        description: String(
            localized: "dangerous potholes that cause problems"
        ),
        issueType: .building,
        severity: .low,
        image: "matt-hoffman-MQjJHTT-diQ-unsplash",
        suggestions: ["pothole filling", "pothole repair", "pothole sealing", "pothole excavation", "pothole removal"]
    ),
    MatterToSolve(
        id: 2,
        title: String(
            localized: "Water leakage"
        ),
        description: String(
            localized: "Water leakage in the street or public spaces"
        ),
        issueType: .building,
        severity: .high,
        image: "arun-prakash-p0_6IwEjK98-unsplash",
        suggestions: ["water leak repair", "water leak sealing"]
    ),
    MatterToSolve(
        id: 3,
        title: String(
            localized: "Street sign"
        ),
        description: String(
            localized: "Missing street sign, damaged, or request to place one"
        ),
        issueType: .building,
        severity: .low,
        image: "zoshua-colah-1BEULYOAnio-unsplash",
        suggestions: ["place a street sign", "change a damaged street sign"]
    ),
    MatterToSolve(
        id: 4,
        title: String(
            localized: "Trafic light"
        ),
        description: String(
            localized: "damaged traffic lights, traffic lights that don't work well"
        ),
        issueType: .building,
        severity: .low,
        image: "eliobed-suarez-PN-YnI5stdQ-unsplash",
        suggestions: ["replace a damaged traffic light", "place a new traffic light"]
    ),
    MatterToSolve(
        id: 5,
        title: String(
            localized: "Lamp"
        ),
        description: String(
            localized: "Burned lamps, missing or request to install or replace"
        ),
        issueType: .building,
        severity: .low,
        image: "mukesh-naik-PZK-dEVBF9g-unsplash",
        suggestions: ["place a new lamp", "replace a damaged lamp", "repair a burned lamp"]
    ),
    MatterToSolve(
        id: 6,
        title: String(
            localized: "Fallen trees"
        ),
        description: String(
            localized: "Fallen trees in the middle of the street, "
        ),
        issueType: .building,
        severity: .medium,
        image: "john-cameron-EVhuJCqYLxM-unsplash",
        suggestions: ["tree trimming", "tree planting", "tree removal"]
    ),
    MatterToSolve(
        id: 7,
        title: String(
            localized: "Flood"
        ),
        description: String(
            localized: "Flood"
        ),
        issueType: .building,
        severity: .high,
        image: "phillip-flores-38wqGW802RM-unsplash",
        suggestions: ["retaing flood prone areas", "repair flood damaged structures"]
    ),
    MatterToSolve(
        id: 8,
        title: String(
            localized: "Waste Management"
        ),
        description: String(
            localized: "problems with waste management"
        ),
        issueType: .publicSpace,
        severity: .low,
        image: "pixel-shot-kxTwgF_uHow-unsplash",
        suggestions: ["improve waste collection systems", "increase recycling programs", "promote waste reduction", "organize community clean-ups", "implement recycling incentives", "encourage composting", "provide information on recycling and waste reduction", "request for volunteers to assist with waste management tasks"]
    )
]
