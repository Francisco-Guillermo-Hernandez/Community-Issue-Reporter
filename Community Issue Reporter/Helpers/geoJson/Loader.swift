//
//  Loader.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 31/5/26.
//

import Foundation
import MapKit

struct GeoJsonLoader {
    static func loadCityBoundaries(from filename: String) -> [MKPolygon] {
        // Locate the GeoJSON file in your App Bundle
        guard let url = Bundle.main.url(forResource: filename, withExtension: "geojson"),
              let data = try? Data(contentsOf: url) else {
            print("GeoJSON file not found.")
            return []
        }
        
        do {
            // Native MapKit parser for GeoJSON
            let objects = try MKGeoJSONDecoder().decode(data)
            var polygons: [MKPolygon] = []
            
            for object in objects {
                // GeoJSON features contain geometries
                if let feature = object as? MKGeoJSONFeature {
                    for geometry in feature.geometry {
                        if let polygon = geometry as? MKPolygon {
                            polygons.append(polygon)
                        } else if let multiPolygon = geometry as? MKMultiPolygon {
                            polygons.append(contentsOf: multiPolygon.polygons)
                        }
                    }
                }
            }
            return polygons
        } catch {
            print("Failed to parse GeoJSON: \(error)")
            return []
        }
    }
}
