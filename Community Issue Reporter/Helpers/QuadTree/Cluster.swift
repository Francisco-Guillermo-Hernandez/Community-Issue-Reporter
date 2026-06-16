//
//  Cluster.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import Foundation
import CoreLocation

// A cluster representation that holds either a single item or multiple items
struct ReportCluster: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let isCluster: Bool
    let totalCount: Int
    
    // Breakdown of states inside this cluster
    var stateCounts: [IssueStatus: Int]
    
    // Reference to the main report if it's just a single item
    var originalReport: MapExplorerReport?
    
    // Helper to determine the dominant state to color-code the cluster icon
    var dominantState: IssueStatus {
        stateCounts.max(by: { $0.value < $1.value })?.key ?? .reported
    }
    
   
}
