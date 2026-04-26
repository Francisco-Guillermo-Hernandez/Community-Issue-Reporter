//
//  MapPickerView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/2/26.
//

import SwiftUI
import CoreLocation
import MapKit

typealias OnConfirm = ((Coordinate, Locator) -> Void)?

struct MapPickerView: View {
    @Binding var coordinate: Coordinate
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D
    @State private var searchText: String
    @State private var hasCenteredOnUser = false
    @State private var locationManager = LocationManager()
    @StateObject private var searchCompleter = SearchCompleter()
    @FocusState private var isSearchFocused: Bool
    @State private var locator: Locator
    @State private var address: String
    @State private var isSearchActive: Bool = false
    @Environment(\.dismissSearch) private var dismissSearch
    
    private let dao = LocatorDAO()
    private let span = MKCoordinateSpan(latitudeDelta: 0.00088, longitudeDelta: 0.00088)
    
    var onConfirm: OnConfirm
    
    init(coordinate: Binding<Coordinate>, onConfirm: OnConfirm = nil) {
        
        self.onConfirm = onConfirm
        self._coordinate = coordinate
        self.selectedCoordinate = getLocation(coordinate)
        self.searchText = ""
        self.address = ""
        self.hasCenteredOnUser = false
        self.locator = Locator(countryCode: "", country: "", region: "", city: "", address: "")
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: getLocation(coordinate),
                span: span
            )
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Move the map where you want to report the issue")
                    .font(.subheadline)
                    .padding(.top, 8)
                
                ZStack {
                    Map(position: $cameraPosition) {
                        UserAnnotation()
                    }
                    .allowsHitTesting(true)
                    .onMapCameraChange { context in
                        selectedCoordinate = context.camera.centerCoordinate
                        handleMapMovement(center: context.camera.centerCoordinate)
                    }
                    .onAppear {
                        self.isSearchFocused = false
                    }
                    .onChange(of: locationManager.lastLocation) { _, newLocation in
                        
                    }
                    .searchable(text: $searchText,  isPresented: $isSearchActive,  prompt: "Search a place")
                    .searchFocused($isSearchFocused)
                    .onChange(of: searchText) { _, newValue in
                        searchCompleter.update(query: newValue, region: currentRegion(c: cameraPosition))
                    }
                    
                    centerMarker
                    mapControls
                }
            }
            .overlay {
                if isSearchFocused {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea(edges: .all)
                        .overlay {
                            SuggestionsResultList(
                                searchText: $searchText,
                                searchCompleter: searchCompleter,
                                applySuggestion: { suggestion in
                                    applySuggestion(suggestion)
                                }
                            )
                        }
                }
            }
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onConfirm?(
                            Coordinate(
                                lat: selectedCoordinate.latitude,
                                lng: selectedCoordinate.longitude
                            ),
                            locator
                        )
                        dismiss()
                    } label: {
                        Label("Submit", systemImage: "checkmark")
                    }
                }
            }
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    ///
    private func applySuggestion(_ suggestion: SearchSuggestion) {
        searchText = suggestion.title
        performSearch(with: suggestion.completion)
        self.isSearchFocused.toggle()
        self.isSearchActive.toggle()
        dismissSearch()
    }
   
    ///
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
              self.locator = dao.findBy(cityName: cityName, country: country)
              self.locator.address = address
          }
      }
    
    ///
    private var centerMarker: some View {
        Image(systemName: "dot.scope")
            .font(.system(size: 50, ))
            .foregroundStyle(Color.accentColor)
            .symbolEffect(.breathe.pulse.wholeSymbol, options: .repeat(.continuous))
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
            .contentShape(Rectangle())
            .accessibilityLabel("Center on user location")
            
            Button {
                zoomIn()
            } label: {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .accessibilityLabel("Zoom in")
            
            
            Button {
                zoomOut()
            } label: {
                Image(systemName: "minus.magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
            }
            .frame(width: 36, height: 36)
            .buttonStyle(.plain)
            .accessibilityLabel("Zoom out")
        }
        .foregroundStyle(Color.primary)
        .padding(10)
        .optionalGlassWithShape(colorScheme, shape: .capsule)
        .padding(.trailing, 16)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    private func zoomIn() {
        zoom(by: 0.5)
    }
    
    private func zoomOut() {
        zoom(by: 2.0)
    }
    
    private func zoom(by factor: CLLocationDegrees) {
        let minimumDelta: CLLocationDegrees = 0.00005
        let maximumDelta: CLLocationDegrees = 120.0
        let fallbackRegion = MKCoordinateRegion(
            center: selectedCoordinate,
            span: span
        )
        let currentRegion = cameraPosition.region ?? fallbackRegion
        
        let latitudeDelta = min(max(currentRegion.span.latitudeDelta * factor, minimumDelta), maximumDelta)
        let longitudeDelta = min(max(currentRegion.span.longitudeDelta * factor, minimumDelta), maximumDelta)
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        cameraPosition = .region(
            MKCoordinateRegion(
                center: currentRegion.center,
                span: span
            )
        )
    }
    
    private func performSearch(with completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        request.region = currentRegion(c: cameraPosition)

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.location.coordinate
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.00445, longitudeDelta: 0.00445)
                )
            )
        }
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

func getLocation(_ coordinate: Binding<Coordinate>) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
        latitude: coordinate.wrappedValue.lat,
        longitude: coordinate.wrappedValue.lng
    )
}

func getLocation(c coordinate: Coordinate) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
        latitude: coordinate.lat,
        longitude: coordinate.lng
    )
}

#Preview {
    @Previewable @State var coordinate: Coordinate = .init(lat: 13.6929, lng: -89.2182)
    MapPickerView(coordinate: $coordinate)

}
