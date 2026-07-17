//
//  MapManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import Foundation
import CoreLocation
import CoreGraphics
import MapKit
import Observation

@MainActor
@Observable
class MapManager {
    var renderedClusters: [ReportCluster] = []
    
    var reports: [MapExplorerReport] = [] {
        didSet {
            treeManager.clear()
            treeManager.insert(reports)
            if let lastRect = lastVisibleRect {
                updateVisibleRegion(rect: lastRect)
            }
        }
    }
    
    private let treeManager = MapTreeManager()
    private var lastVisibleRect: MKMapRect?
    
    func updateVisibleRegion(rect: MKMapRect) {
        self.lastVisibleRect = rect
        
        // Fast Spatial Fetch from Quadtree using the visible map rectangle
        let reportsOnScreen = treeManager.query(visibleMapRect: rect)
        
        // Apply Grid Clustering factoring in map width metric
        self.renderedClusters = MapClusteringEngine.cluster(
            reports: reportsOnScreen,
            mapWidthMetrics: rect.size.width
        )
    }
    
    func fetchReports() async {
        // Let's build the query
        let query = MapExplorerQueryParams(
            lat:  13.868268,
            lng:  -89.850968,
            radius: 300,
            issueTypeIds: [1],
            severityIds: [1],
            statusIds: [1]
        )
        
        do {
            self.reports = try await MapExplorerRepository.shared.listReports( for: query, countryCode: .SV, cityId:  "1")
            print(reports.count)
        } catch {
            print(error)
        }
    }
}
