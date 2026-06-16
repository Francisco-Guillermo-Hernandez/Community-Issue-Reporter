//
//  TreeManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import Foundation
import MapKit

/// Bounding box representation using latitude and longitude coordinates
struct MapBoundingBox {
    let minLat: Double
    let maxLat: Double
    let minLng: Double
    let maxLng: Double
    
    init(minLat: Double, maxLat: Double, minLng: Double, maxLng: Double) {
        self.minLat = minLat
        self.maxLat = maxLat
        self.minLng = minLng
        self.maxLng = maxLng
    }
    
    func contains(lat: Double, lng: Double) -> Bool {
        return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng
    }
    
    func intersects(_ other: MapBoundingBox) -> Bool {
        return !(other.minLng > maxLng ||
                 other.maxLng < minLng ||
                 other.minLat > maxLat ||
                 other.maxLat < minLat)
    }
}

/// A reference class wrapper to allow recursive QuadtreeNode struct composition in Swift
final class Box<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

/// A type-safe Quadtree Node designed specifically for `MapExplorerReport` objects
struct QuadtreeNode {
    let boundary: MapBoundingBox
    let capacity: Int
    private(set) var reports: [MapExplorerReport] = []
    
    private(set) var northWest: Box<QuadtreeNode>?
    private(set) var northEast: Box<QuadtreeNode>?
    private(set) var southWest: Box<QuadtreeNode>?
    private(set) var southEast: Box<QuadtreeNode>?
    
    var isSubdivided: Bool {
        northWest != nil
    }
    
    init(boundary: MapBoundingBox, capacity: Int = 32) {
        self.boundary = boundary
        self.capacity = capacity
    }
    
    mutating func insert(_ report: MapExplorerReport) -> Bool {
        guard boundary.contains(lat: report.lat, lng: report.lng) else {
            return false
        }
        
        if reports.count < capacity && !isSubdivided {
            reports.append(report)
            return true
        }
        
        if !isSubdivided {
            subdivide()
        }
        
        if northWest?.value.insert(report) == true { return true }
        if northEast?.value.insert(report) == true { return true }
        if southWest?.value.insert(report) == true { return true }
        if southEast?.value.insert(report) == true { return true }
        
        return false
    }
    
    private mutating func subdivide() {
        let midLat = (boundary.minLat + boundary.maxLat) / 2.0
        let midLng = (boundary.minLng + boundary.maxLng) / 2.0
        
        let nwBox = MapBoundingBox(minLat: midLat, maxLat: boundary.maxLat, minLng: boundary.minLng, maxLng: midLng)
        let neBox = MapBoundingBox(minLat: midLat, maxLat: boundary.maxLat, minLng: midLng, maxLng: boundary.maxLng)
        let swBox = MapBoundingBox(minLat: boundary.minLat, maxLat: midLat, minLng: boundary.minLng, maxLng: midLng)
        let seBox = MapBoundingBox(minLat: boundary.minLat, maxLat: midLat, minLng: midLng, maxLng: boundary.maxLng)
        
        northWest = Box(QuadtreeNode(boundary: nwBox, capacity: capacity))
        northEast = Box(QuadtreeNode(boundary: neBox, capacity: capacity))
        southWest = Box(QuadtreeNode(boundary: swBox, capacity: capacity))
        southEast = Box(QuadtreeNode(boundary: seBox, capacity: capacity))
        
        let existingReports = reports
        reports.removeAll(keepingCapacity: true)
        
        for report in existingReports {
            if northWest?.value.insert(report) == true { continue }
            if northEast?.value.insert(report) == true { continue }
            if southWest?.value.insert(report) == true { continue }
            if southEast?.value.insert(report) == true { continue }
        }
    }
    
    func query(range: MapBoundingBox, found: inout [MapExplorerReport]) {
        guard boundary.intersects(range) else {
            return
        }
        
        for report in reports {
            if range.contains(lat: report.lat, lng: report.lng) {
                found.append(report)
            }
        }
        
        if isSubdivided {
            northWest?.value.query(range: range, found: &found)
            northEast?.value.query(range: range, found: &found)
            southWest?.value.query(range: range, found: &found)
            southEast?.value.query(range: range, found: &found)
        }
    }
}

/// Manager that handles indexing of `MapExplorerReport` items and query bounds translations
class MapTreeManager {
    private var root: QuadtreeNode
    
    init() {
        // Initialize with a global boundary covering all latitudes and longitudes
        let globalBoundary = MapBoundingBox(minLat: -90.0, maxLat: 90.0, minLng: -180.0, maxLng: 180.0)
        self.root = QuadtreeNode(boundary: globalBoundary)
    }
    
    /// Clears all items in the index
    func clear() {
        let globalBoundary = MapBoundingBox(minLat: -90.0, maxLat: 90.0, minLng: -180.0, maxLng: 180.0)
        self.root = QuadtreeNode(boundary: globalBoundary)
    }
    
    /// Indexes a list of reports into the quadtree
    func insert(_ reports: [MapExplorerReport]) {
        for report in reports {
            _ = root.insert(report)
        }
    }
    
    /// Queries reports located inside the specified coordinate bounding box
    func query(range: MapBoundingBox) -> [MapExplorerReport] {
        var results: [MapExplorerReport] = []
        root.query(range: range, found: &results)
        return results
    }
    
    /// Queries reports located inside the specified visible MKMapRect
    func query(visibleMapRect rect: MKMapRect) -> [MapExplorerReport] {
        // Convert the corners of the MKMapRect to coordinates
        let topLeft = MKMapPoint(x: rect.origin.x, y: rect.origin.y).coordinate
        let bottomRight = MKMapPoint(x: rect.maxX, y: rect.maxY).coordinate
        
        // Latitude is inverted in map coordinates (y goes down, latitude goes down)
        let minLat = min(topLeft.latitude, bottomRight.latitude)
        let maxLat = max(topLeft.latitude, bottomRight.latitude)
        
        // Longitude goes up from left to right (x goes up, longitude goes up)
        let minLng = min(topLeft.longitude, bottomRight.longitude)
        let maxLng = max(topLeft.longitude, bottomRight.longitude)
        
        let range = MapBoundingBox(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng)
        return query(range: range)
    }
}
