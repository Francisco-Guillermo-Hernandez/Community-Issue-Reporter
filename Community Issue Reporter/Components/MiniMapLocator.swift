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
    @Binding var locator: Locator
    @Environment(\.colorScheme) private var colorScheme
    var onExpandMap: ((Coordinate) -> Void)?
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D
    @State private var locationManager = LocationManager()
    
    private let span = MKCoordinateSpan(latitudeDelta: 0.00704, longitudeDelta: 0.00704)
    
    init(
        coordinate: Binding<Coordinate>,
        locator: Binding<Locator>,
        onExpandMap: ((Coordinate) -> Void)? = nil
    ) {
        self._coordinate = coordinate
        self._locator = locator
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
            }
            .onMapCameraChange { context in
                selectedCoordinate = context.camera.centerCoordinate
                handleMapMovement(center: context.camera.centerCoordinate)
                
                coordinate = Coordinate(
                    lat: context.camera.centerCoordinate.latitude,
                    lng: context.camera.centerCoordinate.longitude
                )
            }
            .aspectRatio(4/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius, style: .continuous))
//            .onMapCameraChange { context in
//                /// Update coordinates when the user interacts with the map
//                selectedCoordinate = context.camera.centerCoordinate
//            }
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
                    .background(Color.black.opacity(0.001))
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
                    .background(Color.black.opacity(0.001))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Expand Map")
        }
        .foregroundStyle(Color.primary)
        .padding(10)
        .optionalGlassWithShape(colorScheme, shape: .capsule)
        .padding(.trailing, 16)
        .padding(.top, 16)
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
    
    private func handleMapMovement(center: CLLocationCoordinate2D) {
          let location = CLLocation(latitude: center.latitude, longitude: center.longitude)

          Task {
              try? await Task.sleep(for: .milliseconds(500))
              guard !Task.isCancelled else { return }
              guard let request = MKReverseGeocodingRequest(location: location) else { return }
              let mapItems = try? await request.mapItems
              guard let mapItem = mapItems?.first else { return }
              
              let address = mapItem.address?.fullAddress ??  mapItem.address?.shortAddress ?? "Unknown"
              
              let country = mapItem.addressRepresentations?.region?.identifier
              ?? mapItem.addressRepresentations?.regionName
              ?? "-1"
              
              let cityName = mapItem.addressRepresentations?.cityName ?? "-1"
              self.locator = LocatorDAO.shared.findBy(cityName: cityName, country: country)
              self.locator.address = address
              
              ReportDataModel.shared.updateLocator(with: locator)
          }
      }
}

#Preview {
    @Previewable @State var coordinate: Coordinate = .init(lat: 13.6929, lng: -89.2182)
    @Previewable @State var locator: Locator = .init(id: "", countryCode: "", country: "", region: "", city: "", address: "")
    MapPickerView(coordinate: $coordinate, locator: $locator)
}
