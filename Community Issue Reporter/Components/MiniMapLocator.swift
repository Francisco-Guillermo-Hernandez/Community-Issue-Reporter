//
//  MiniMapLocator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/3/26.
//

import SwiftUI
import CoreLocation
import MapKit

enum ChangeLocationType: String, Equatable {
    case automatic
    case user
}

struct MiniMapLocator: View {
    @Binding var coordinate: Coordinate
    @Binding var locator: Locator
    @Binding var isLoading: Bool
    @Environment(SettingsStore.self) var settings
    @Environment(\.colorScheme) private var colorScheme
    var onExpandMap: ((Coordinate) -> Void)?
    var onChange: (ChangeLocationType) -> Void
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D
    @State private var locationManager = LocationManager()
    @State private var notAllowedCountry: Bool = false
    @State private var isAwaitingLocation: Bool = false
    @State private var type: ChangeLocationType = .automatic
    
    private let span = MKCoordinateSpan(latitudeDelta: 0.00704, longitudeDelta: 0.00704)
    
    init(
        coordinate: Binding<Coordinate>,
        locator: Binding<Locator>,
        isLoading: Binding<Bool>,
        onExpandMap: ((Coordinate) -> Void)? = nil,
        onChange: @escaping @Sendable (ChangeLocationType) -> Void
    ) {
        self._coordinate = coordinate
        self._locator = locator
        self._isLoading = isLoading
        self.selectedCoordinate = getLocation(coordinate)
        self.onExpandMap = onExpandMap
        self.onChange = onChange
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: getLocation(coordinate),
                span: span
            )
        )
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .topLeading) {
                Map(position: $cameraPosition, interactionModes: [.pan, .rotate]) {
                    UserAnnotation()
                }
                .contentMargins(.bottom, 8, for: .scrollContent)
                .contentMargins(.leading, 8, for: .scrollContent)
                .task {
                    if settings.useMyCurrentLocation {
                        centerOnUser()
                    }
                }
                .onMapCameraChange(frequency: .onEnd) { context in
                    if cameraPosition.positionedByUser {
                        onChange(.user)
                    }
                }
                .onMapCameraChange { context in
                    selectedCoordinate = context.camera.centerCoordinate
                    locator.cityId = ""
                    ReportDataModel.shared.locator.cityId = ""
                    
                    var locationType: ChangeLocationType = .automatic
                   
                    /// set if a user has requested their location
                    if type == .user && isAwaitingLocation == false {
                        locationType = .user
                    }
                    
                    handleMapMovement(center: context.camera.centerCoordinate, locationType)
                    
                    coordinate = Coordinate(
                        lat: context.camera.centerCoordinate.latitude,
                        lng: context.camera.centerCoordinate.longitude
                    )
                }
                .aspectRatio(4/3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
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
                .onChange(of: locationManager.lastLocation) { _, newLocation in
                    if isAwaitingLocation, newLocation != nil {
                        centerOnUser()
                    }
                }
                .alert(String(localized: "Out of bounds"), isPresented: $notAllowedCountry) {
                    Button(String(localized: "OK"), role: .close) {
                        cameraPosition = AuthViewModel.shared.cameraPosition
                        notAllowedCountry = false
                    }
                } message: {
                    Text(String(localized: "This country is not supported at the moment."))
                }
               
                mapControls
            }
            
            centerMarker
        }
    }
    
    
    private var centerMarker: some View {
        Image(systemName: "plus")
            .font(.system(size: 40, weight: .light))
            .foregroundColor(Color.theme.primary)
            .frame(maxWidth: .infinity, maxHeight: 250)
            .accessibilityHidden(true)
    }
    
    private var mapControls: some View {
        VStack(spacing: .themeSpacing * 6) {
            Button {
                centerOnUser()
            } label: {
                Image(systemName: "location")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("LocateButton")
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
    @State private var geocodeTask: Task<Void, Never>?
    
    private func centerOnUser() {
        if let lastLocation = locationManager.lastLocation {
            isAwaitingLocation = false
            type = .user
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: lastLocation.coordinate,
                    span: span
                )
            )
            
            selectedCoordinate = lastLocation.coordinate
            locator.cityId = ""
            ReportDataModel.shared.locator.cityId = ""
            handleMapMovement(center: lastLocation.coordinate, .user)
        } else {
            isAwaitingLocation = true
            locationManager.requestAuthorization()
        }
    }
    
    private func handleMapMovement(center: CLLocationCoordinate2D, _ type: ChangeLocationType) {
          let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        self.isLoading = true
          geocodeTask?.cancel()
          geocodeTask = Task {
              try? await Task.sleep(for: .milliseconds(500))
              guard !Task.isCancelled else { return }
              guard let request = MKReverseGeocodingRequest(location: location) else { return }
              let mapItems = try? await request.mapItems
              guard !Task.isCancelled else { return }
              guard let mapItem = mapItems?.first else { return }
              
              let address = mapItem.address?.fullAddress ??  mapItem.address?.shortAddress ?? "Unknown"
              let countryCode = mapItem.addressRepresentations?.region?.identifier ?? "SV"
              
              var cityName = mapItem.addressRepresentations?.cityName ?? "San Salvador"
              
              let isAllowedCountry = isAllowedCountry(countryCode)
              
              notAllowedCountry = !isAllowedCountry
              
              /// Workaround
              /// Rename the city name because in Apple Maps is Wrong!
              if cityName == "Sesuntepeque" {
                  cityName = "Sensuntepeque"
              }
              
              if cityName == "Unión" || cityName == "Union" {
                  cityName = "La Unión"
              }
              
              var newLocator = LocatorDAO.shared.findBy(countryCode: countryCode, cityName: cityName)
              if newLocator.cityId.isEmpty {
                  newLocator = LocatorDAO.shared.findByNearest(countryCode: countryCode, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
              }
              newLocator.address = address
              
              await MainActor.run {
                  self.locator = newLocator
                  ReportDataModel.shared.updateLocator(with: newLocator)
                  self.isLoading = false
                  self.onChange(type)
              }
          }
      }
    
}

#Preview("Map Picker") {
    @Previewable @State var coordinate: Coordinate = .init(lat: 13.6929, lng: -89.2182)
    @Previewable @State var locator: Locator = .init()
    MapPickerView(coordinate: $coordinate, locator: $locator, onChange: { _ in
        print("changed location")
        print(locator.address)
        print(locator.countryCode)
        print(locator.secondLevel)
        print(locator.cityId)
    })
    .environment(SubscriptionManager.shared)
}


#Preview("Minimap") {
    @Previewable @State var coordinate: Coordinate = .init(lat: 13.6929, lng: -89.2182)
    @Previewable @State var locator: Locator = .init()
    @Previewable @State var isLoading: Bool = false
    MiniMapLocator(
        coordinate: $coordinate,
        locator: $locator,
        isLoading: $isLoading,
        onExpandMap: { _ in
//            showMapPickerSheet.toggle()
        },
        onChange: { type in
            print(type)
            print("user has changed the location,")
        }
    )
    .environment(SettingsStore())
    .environment(SubscriptionManager.shared)
}
