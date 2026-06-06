//
//  CityDelimiterView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 31/5/26.
//

import SwiftUI
import MapKit

struct CityDelimiterView: View {
    // Center map around your default San Salvador/El Salvador coordinates
       @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 13.701270, longitude: -89.224432),
           span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
       ))
       
       // Load polygons from your bundle file
       @State private var cityBoundaries: [MKPolygon] = GeoJsonLoader.loadCityBoundaries(from: "SV+SanSalvador")

       var body: some View {
           Map(position: $position) {
               // Render the city borders dynamically
               ForEach(0..<cityBoundaries.count, id: \.self) { index in
                   MapPolygon(cityBoundaries[index])
                       .stroke(.blue, lineWidth: 2)
                       .foregroundStyle(.blue.opacity(0.15))
               }
           }
           .mapStyle(.standard(emphasis: .muted)) // Keeps the base map subtle so borders pop
           .ignoresSafeArea()
       }
}

#Preview {
    CityDelimiterView()
}
