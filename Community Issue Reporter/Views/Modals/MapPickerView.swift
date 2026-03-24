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
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    @State private var selectedCoordinate = CLLocationCoordinate2D(latitude: 13.6929, longitude: -89.2182)
    @State private var searchText = ""
    @State private var isDrivingMode = true
    @State private var hasCenteredOnUser = false
    @State private var locationManager = LocationManager()
    @FocusState private var isSearchFocused: Bool
    var onConfirm: ((CLLocationCoordinate2D) -> Void)?

    var body: some View {
        NavigationStack {
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
                            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                        )
                    )
                    selectedCoordinate = newLocation.coordinate
                }
                .ignoresSafeArea(edges: .bottom)

                centerMarker
                mapControls
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                SearchBar(
                    text: $searchText,
                    onSubmit: {
                        performSearch()
                        isSearchFocused = false
                    },
                    onFocusChange: { _ in },
                    onUserProfileTap: {},
                    isFocused: $isSearchFocused
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
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
        VStack(spacing: 10) {
            Button {
                centerOnUser()
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Center on user location")

            Button {
                isDrivingMode.toggle()
            } label: {
                Image(systemName: isDrivingMode ? "car.fill" : "car")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Toggle driving mode")
        }
        .foregroundStyle(Color.primary)
        .padding(10)
        .optionalGlassEffect(colorScheme, cornerRadius: 18)
        .padding(.trailing, 16)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    private func currentRegion() -> MKCoordinateRegion {
        if case .region(let region) = cameraPosition {
            return region
        }
        return MKCoordinateRegion(
            center: selectedCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    }

    private func performSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmed
        request.region = currentRegion()

        Task {
            let result = try? await MKLocalSearch(request: request).start()
            guard let coordinate = result?.mapItems.first?.placemark.coordinate else { return }
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
