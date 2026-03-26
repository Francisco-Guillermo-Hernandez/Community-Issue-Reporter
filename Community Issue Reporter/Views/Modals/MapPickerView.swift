//
//  MapPickerView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/2/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.6929, longitude: -89.2182),
            span: MKCoordinateSpan(latitudeDelta: 0.00088, longitudeDelta: 0.00088)
        )
    )
    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 13.6929, longitude: -89.2182)
    @State private var searchText = ""
    @State private var hasCenteredOnUser = false
    @State private var locationManager = LocationManager()
    @FocusState private var isSearchFocused: Bool
    var onConfirm: ((CLLocationCoordinate2D) -> Void)?

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(position: $cameraPosition) {
                        UserAnnotation()
                    }
                    .onMapCameraChange { context in
                        selectedCoordinate = context.camera.centerCoordinate
                    }
                    .onAppear {
                        locationManager.requestAuthorization()
                    }
                    .onChange(of: locationManager.lastLocation) { _, newLocation in
                        guard let newLocation, !hasCenteredOnUser else { return }
                        hasCenteredOnUser = true
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: newLocation.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.00088, longitudeDelta: 0.00088)
                            )
                        )
                        selectedCoordinate = newLocation.coordinate
                    }
                    .ignoresSafeArea(edges: .bottom)

                    centerMarker
                    mapControls
                }
            }
        
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
                        onConfirm?(selectedCoordinate)
                        dismiss()
                    } label: {
                        Label("Submit", systemImage: "checkmark")
                    }
                }
            }
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
//            .safeAreaInset(edge: .bottom, spacing: 0) {
//                SearchBar(
//                    text: $searchText,
//                    onSubmit: {
//                        performSearch()
//                        isSearchFocused = false
//                    },
//                    onFocusChange: { _ in },
//                    onUserProfileTap: {},
//                    isFocused: $isSearchFocused
//                )
//                .padding(.horizontal, 16)
//                .padding(.bottom, 10)
//            }
        }
       

    }

    private var centerMarker: some View {
        Image(systemName: "mappin.circle.fill")
            .font(.system(size: 34, weight: .semibold))
            .foregroundStyle(Color.blue)
            .shadow(radius: 4, y: 2)
            .offset(y: -12)
            .accessibilityHidden(true)
    }

    private var mapControls: some View {
        VStack(spacing: 16) {
            Button {
                centerOnUser()
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Center on user location")
            
            Button {
                zoomIn()
            } label: {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Zoom in")
            
            
            Button {
                zoomOut()
            } label: {
                Image(systemName: "minus.magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Zoom out")
        }
        .foregroundStyle(Color.primary)
        .padding(10)
        .optionalGlassEffect(colorScheme, cornerRadius: 16)
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
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        let currentRegion = cameraPosition.region ?? fallbackRegion
        
        let latitudeDelta = min(max(currentRegion.span.latitudeDelta * factor, minimumDelta), maximumDelta)
        let longitudeDelta = min(max(currentRegion.span.longitudeDelta * factor, minimumDelta), maximumDelta)
        
        cameraPosition = .region(
            MKCoordinateRegion(
                center: currentRegion.center,
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        )
    }
    
    private func performSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmed
        request.region = MKCoordinateRegion(
            center: selectedCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )

        Task {
            let result = try? await MKLocalSearch(request: request).start()
            let coordinate: CLLocationCoordinate2D?
            if #available(iOS 26, *) {
                coordinate = result?.mapItems.first?.location.coordinate
            } else {
                coordinate = result?.mapItems.first?.placemark.coordinate
            }
            guard let coordinate else { return }
            await MainActor.run {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                )
                selectedCoordinate = coordinate
            }
        }
    }

    private func centerOnUser() {
        if let lastLocation = locationManager.lastLocation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: lastLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
            selectedCoordinate = lastLocation.coordinate
        } else {
            locationManager.requestAuthorization()
        }
    }
}

#Preview {
    MapPickerView()
}
