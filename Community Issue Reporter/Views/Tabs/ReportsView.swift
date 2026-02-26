//
//  Reports.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import CoreLocation
import MapKit
import Observation
import SwiftUI
internal import Combine

struct ReportsView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.6929, longitude: -89.2182),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )
    @State private var hasCenteredOnUser = false
    @State private var searchText: String = ""
    @State private var selectedStatuses: Set<IssueStatus> = Set(IssueStatus.allCases)
    @State private var searchMarker: IssueMarker?
    @State private var locationManager = LocationManager()
    @State private var showSearchOverlay: Bool = false
    @State private var showUserProfileOverlay: Bool = false
    @State private var isPresented: Bool = false
    @StateObject private var searchCompleter = SearchCompleter()
    @FocusState private var isSearchFocused: Bool
    @FocusState private var isOverlaySearchFocused: Bool
    @State private var offsetY: CGFloat = 0
    
    var progress: CGFloat {
        return max(min(offsetY / 100, 1), 0)
    }

    private let issues: [IssueMarker] = [
        IssueMarker(title: String(localized: "Pothole near park"), status: .reported, coordinate: CLLocationCoordinate2D(latitude: 13.6996, longitude: -89.1915)),
        IssueMarker(title: String(localized: "Lamp not working"), status: .inProgress, coordinate: CLLocationCoordinate2D(latitude: 13.7048, longitude: -89.2234)),
        IssueMarker(title: String(localized: "Fixed sidewalk"), status: .fixed, coordinate: CLLocationCoordinate2D(latitude: 13.6894, longitude: -89.2308)),
        IssueMarker(title: String(localized: "Water leak"), status: .reported, coordinate: CLLocationCoordinate2D(latitude: 13.6881, longitude: -89.2091)),
        IssueMarker(title: String(localized: "Fallen tree"), status: .inProgress, coordinate: CLLocationCoordinate2D(latitude: 13.7072, longitude: -89.2047))
    ]

    private var filteredIssues: [IssueMarker] {
        issues.filter { selectedStatuses.contains($0.status) }
    }

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()

                ForEach(filteredIssues) { issue in
                    Annotation(issue.title, coordinate: issue.coordinate) {
                        IssuePin(status: issue.status)
                    }
                }

                if let searchMarker {
                    Annotation(searchMarker.title, coordinate: searchMarker.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                            .shadow(radius: 3)
                    }
                }
            }

        }
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 16) {
                SearchBar(
                    text: $searchText,
                    onSubmit: {
                        performSearch()
                        showSearchOverlay = false
                    },
                    onFocusChange: { isFocused in
                        showSearchOverlay = isFocused
                    },
                    onUserProfileTap: {
                        showUserProfileOverlay.toggle()
                    },
                    isFocused: $isSearchFocused
                )
                
                StatusFilterRow(selectedStatuses: $selectedStatuses)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
        .onChange(of: searchText) { _, newValue in
            searchCompleter.update(query: newValue, region: currentRegion())
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
        }
        .sheet(isPresented: $showUserProfileOverlay) {
            UserProfileView()
        }
        .overlay {
            /// customized overlay to show the list of places into a List
            if showSearchOverlay {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .background(.background.opacity(0.25))
                    .ignoresSafeArea()
                    .overlay {
                        VStack {
                            SearchBar(
                                text: $searchText,
                                onSubmit: {
                                    performSearch()
                                    showSearchOverlay = false
                                },
                                onFocusChange: { isFocused in
                                    showSearchOverlay = isFocused
                                },
                                onUserProfileTap: {},
                                isFocused: $isOverlaySearchFocused
                            )
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .padding(.top, 10)
                            
                            List {
                                let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if trimmed.isEmpty {
                                    Text(String(localized: "Start typing to search."))
                                        .foregroundStyle(.secondary)
                                } else if searchCompleter.suggestions.isEmpty {
                                    Text(String(localized: "No matches found."))
                                        .foregroundStyle(.secondary)
                                } else {
                                    ForEach(searchCompleter.suggestions) { suggestion in
                                        Button {
                                            applySuggestion(suggestion)
                                        } label: {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(suggestion.title)
                                                    .foregroundStyle(.primary)
                                                if !suggestion.subtitle.isEmpty {
                                                    Text(suggestion.subtitle)
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                            .padding(.vertical, 6)
                                        }
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                            .clipped()
                        }
                        .onAppear {
                            isOverlaySearchFocused = true
                        }
                    }
            }

        }
//        .transition(.scale(scale: 0, anchor: .top).combined(with: .opacity))
       
//        .animation(.easeInOut(duration: 0.25), value: showSearchOverlay)
//        .overlay(alignment: .bottomTrailing) {
//            Group {
//                if #available(iOS 26, *) {
//                    BottomFloatingToolBar()
//                        .glassEffect(.regular, in: .capsule)
//                }
//            }
//            .offset(x: -16, y: 0)
//        }
        
        
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = currentRegion()

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.location.coordinate
            searchMarker = IssueMarker(title: item.name ?? String(localized: "Result"), status: .reported, coordinate: coordinate)
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
        }
    }

    private func performSearch(with completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        request.region = currentRegion()

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.location.coordinate
            searchMarker = IssueMarker(title: item.name ?? String(localized: "Result"), status: .reported, coordinate: coordinate)
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
        }
    }

    private func applySuggestion(_ suggestion: SearchSuggestion) {
        searchText = suggestion.title
        performSearch(with: suggestion.completion)
        showSearchOverlay = false
        isOverlaySearchFocused = false
    }

    private func currentRegion() -> MKCoordinateRegion {
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
    
    @ViewBuilder
    private func BottomFloatingToolBar() -> some View {
            VStack(spacing: 35) {
                Button {
                    
                } label: {
                    Image(systemName: "car.fill")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "location")
                }
            }
            .font(.title3)
            .foregroundStyle(Color.primary)
            .padding(.vertical, 55)
            .padding(.horizontal, 16)
        }
}

private struct IssueMarker: Identifiable {
    let id = UUID()
    let title: String
    let status: IssueStatus
    let coordinate: CLLocationCoordinate2D
}

private struct IssuePin: View {
    let status: IssueStatus

    var body: some View {
        Image(systemName: "mappin.and.ellipse")
            .font(.title2)
            .foregroundStyle(status.color)
            .shadow(radius: 2)
    }
}

private struct SearchSuggestion: Identifiable {
    let title: String
    let subtitle: String
    let completion: MKLocalSearchCompletion

    var id: String {
        "\(title)|\(subtitle)"
    }
}

private final class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
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

private struct SearchBar: View {
    
    @Binding var text: String
    let onSubmit: () -> Void
    let onFocusChange: (Bool) -> Void
    let onUserProfileTap: () -> Void
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        
        VStack {
            HStack() {
                HStack() {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .padding(.leading, 16)
                    
                    TextField("Search...", text: $text)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding(.vertical, 12)
                        .focused($isFocused)
                        .onSubmit(onSubmit)
                        .onChange(of: isFocused) { _, newValue in
                            onFocusChange(newValue)
                        }
                }
                .glassEffect()
                .animation(
                    .interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0),
                    value: isFocused
                )
                
                HStack {
                    if isFocused {
                        Button {
                            isFocused = false
                            text = ""
                        } label: {
                            ZStack {
                                Group {
                                    if #available(iOS 26, *) {
                                        Image(systemName: "xmark")
                                            .frame(width: 48, height: 48)
                                            .glassEffect(in: .circle)
                                    } else {
                                        Image(systemName: "xmark")
                                            .frame(width: 48, height: 48)
                                            .background(.ultraThinMaterial, in: .circle)
                                    }
                                }
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary)
                                .transition(.blurReplace)
                            }
                        }
                    } else {
                        Button {
                            onUserProfileTap()
                        } label: {
                            Text("FH")
                                .font(.title2.bold())
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.white)
                                .background(.gray, in: .circle)
                                .transition(.blurReplace)
                        }
                    }
                }
            }
        }
       
    }
}


private struct StatusFilterRow: View {
    @Binding var selectedStatuses: Set<IssueStatus>
    @State private var issueType: IssueTypes = .all

    var body: some View {
        
        HStack {
        
            Menu {
                
                Picker("Issue Type", selection: $issueType) {
                    ForEach(IssueTypes.allCases, id: \.self) { issueType in
                        Text(issueType.title).tag(issueType.title)
                    }
                }
            
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                   .fontWeight(.semibold)
                   .foregroundStyle(.primary)
                   .transition(.blurReplace)
                   .frame(width: 24, height: 24)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    
                    ForEach(IssueStatus.allCases) { status in
                        let isSelected = selectedStatuses.contains(status)
                        Button {
                            toggle(status)
                        } label: {
                            
                            HStack {
                                Image(systemName: status.iconName)
                                    .tint(.white)
                                    
                                Text(LocalizedStringKey(status.title))
                                    .font(.subheadline.weight(.semibold))
                                    
                            }
                               
                                .foregroundStyle(isSelected ? Color.white : Color.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? status.color : status.color.opacity(0.55))
                                        .brightness(-0.2)
                                )
                                .glassEffect(in: .capsule)
                                .transition(.blurReplace)
                                .overlay(
                                    Capsule()
                                        .stroke(status.color.opacity(isSelected ? 0.0 : 0.7), lineWidth: 1)
                                )
                            
                        }
                    }
                    .accessibility(identifier: "statusFilterButtons")
                }
            }
        }
    }

    private func toggle(_ status: IssueStatus) {
        if selectedStatuses.contains(status) {
            selectedStatuses.remove(status)
        } else {
            selectedStatuses.insert(status)
        }
    }
}

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var lastLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
}




#Preview {
    ReportsView()
}
