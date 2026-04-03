//
//  SearchCompleter.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import CoreLocation
import MapKit
import SwiftUI
internal import Combine

final class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published private(set) var suggestions: [SearchSuggestion] = []
    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .address]
    }

    func update(query: String, region: MKCoordinateRegion) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            suggestions = []
            return
        }

        completer.region = region
        completer.queryFragment = trimmed
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results.map {
            SearchSuggestion(title: $0.title, subtitle: $0.subtitle, completion: $0)
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        suggestions = []
    }
}

struct SearchSuggestion: Identifiable {
    let title: String
    let subtitle: String
    let completion: MKLocalSearchCompletion

    var id: String {
        "\(title)|\(subtitle)"
    }
}


func currentRegion(c cameraPosition: MapCameraPosition) -> MKCoordinateRegion {
    if let region = cameraPosition.region {
        return region
    }

    if let camera = cameraPosition.camera {
        return MKCoordinateRegion(
            center: camera.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }

    return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 13.6929, longitude: -89.2182),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
}
