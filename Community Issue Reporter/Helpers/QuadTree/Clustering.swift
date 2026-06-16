//
//  Clustering.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import Foundation
import CoreLocation

class MapClusteringEngine {
    
    /// Groups reports into clusters based on map scale / zoom level
    /// - Parameters:
    ///   - reports: The filtered reports currently inside the bounding box
    ///   - mapWidthMetrics: A factor representing zoom (e.g., context.rect.size.width)
    static func cluster(reports: [MapExplorerReport], mapWidthMetrics: Double) -> [ReportCluster] {
        guard !reports.isEmpty else { return [] }
        
        // 1. Dynamically calculate grid cell size based on the map's visible width.
        // Higher width means zoomed out -> larger grid size -> more aggressive clustering.
        let baseGridSize = 0.05 // Baseline degree span
        let scaleFactor = mapWidthMetrics / 1_000_000 // Adjust this denominator to tune sensitivity
        let gridSize = max(baseGridSize * scaleFactor, 0.0005) // Caps how small cells get when fully zoomed in
        
        // Dictionary key format: "gridX_gridY"
        var gridBuckets: [String: [MapExplorerReport]] = [:]
        
        // 2. Assign each report to a specific grid bucket
        for report in reports {
            let gridX = Int(floor(report.lng / gridSize))
            let gridY = Int(floor(report.lat / gridSize))
            let key = "\(gridX)_\(gridY)"
            
            gridBuckets[key, default: []].append(report)
        }
        
        // 3. Convert grid buckets into final ReportCluster structures
        var finalClusters: [ReportCluster] = []
        
        for (_, reportsInCell) in gridBuckets {
            if reportsInCell.count == 1 {
                // Keep it clean: Only 1 item in this grid cell, don't show a generic cluster bubble
                let singleReport = reportsInCell[0]
                let clusterItem = ReportCluster(
                    coordinate: singleReport.clLocation,
                    isCluster: false,
                    totalCount: 1,
                    stateCounts: [singleReport.status: 1],
                    originalReport: singleReport
                )
                finalClusters.append(clusterItem)
            } else {
                // Compute the center point (average lat/lng) for the cluster placement
                var totalLat: Double = 0
                var totalLng: Double = 0
                var counts: [IssueStatus: Int] = [:]
                
                // Initialize counts dictionary for safety
                for state in IssueStatus.allCases { counts[state] = 0 }
                
                for report in reportsInCell {
                    totalLat += report.lat
                    totalLng += report.lng
                    counts[report.status, default: 0] += 1
                }
                
                let avgCoordinate = CLLocationCoordinate2D(
                    latitude: totalLat / Double(reportsInCell.count),
                    longitude: totalLng / Double(reportsInCell.count)
                )
                
                let combinedCluster = ReportCluster(
                    coordinate: avgCoordinate,
                    isCluster: true,
                    totalCount: reportsInCell.count,
                    stateCounts: counts,
                    originalReport: nil
                )
                finalClusters.append(combinedCluster)
            }
        }
        
        return finalClusters
    }
}
