//
//  MiniMapLocator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/3/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct MiniMapLocator: View {
    @Binding var coordinate: Coordinate
    @Environment(\.colorScheme) private var colorScheme
    var onExpandMap: ((Coordinate) -> Void)?
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D
    @State private var locationManager = LocationManager()
    
    private let span = MKCoordinateSpan(latitudeDelta: 0.00704, longitudeDelta: 0.00704)
    
    init(coordinate: Binding<Coordinate>, onExpandMap: ((Coordinate) -> Void)? = nil) {
        self._coordinate = coordinate
        self.selectedCoordinate = getLocation(coordinate)
        self.onExpandMap = onExpandMap
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: getLocation(coordinate),
                span: span
            )
        )
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Map(position: $cameraPosition) {
                UserAnnotation()
            }
            .onAppear {
                /// Request the location permissions to the user
                locationManager.requestAuthorization()
            }
            .onChange(of: locationManager.lastLocation) { _, newLocation in
                guard let newLocation else { return }
                /// Center at the user location
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: newLocation.coordinate,
                        span: span
                    )
                )
                selectedCoordinate = newLocation.coordinate
            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .onMapCameraChange { context in
                /// Update coordinates when the user interacts with the map
                selectedCoordinate = context.camera.centerCoordinate
            }
            .onChange(of: coordinate) { _, newValue in
                DispatchQueue.main.async {
                    /// Center the location when the coordinate was updated using MapPicker
                    self.cameraPosition = .region(
                        MKCoordinateRegion(
                            center: getLocation(c: newValue),
                            span: span
                        )
                    )
                }
            }
            
            
            centerMarker
            mapControls
        }
    }
    
    
    private var centerMarker: some View {
        Image(systemName: "plus")
            .font(.system(size: 40, weight: .light))
            .foregroundColor(.cyan)
            .frame(maxWidth: .infinity, maxHeight: 250)
            .accessibilityHidden(true)
    }
    
    private var mapControls: some View {
        VStack(spacing: 16) {
            Button {
                centerOnUser()
            } label: {
                Image(systemName: "location")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Locate")
            
            Button {
                /// Send back updated coordinate
                onExpandMap?(
                    Coordinate(
                        lat: selectedCoordinate.latitude,
                        lng: selectedCoordinate.longitude
                    ),
                )
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Expand Map")
        }
        .foregroundStyle(Color.primary)
        .padding(10)
        .optionalGlassEffect(colorScheme, cornerRadius: 16)
        .padding(.trailing, 8)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .topTrailing)
    }
    
    private func centerOnUser() {
        if let lastLocation = locationManager.lastLocation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: lastLocation.coordinate,
                    span: span
                )
            )
            selectedCoordinate = lastLocation.coordinate
        } else {
            locationManager.requestAuthorization()
        }
    }
}

#Preview {
    @Previewable @State var coordinate: Coordinate = .init(lat: 13.6929, lng: -89.2182)
    MiniMapLocator(coordinate: $coordinate)
}
