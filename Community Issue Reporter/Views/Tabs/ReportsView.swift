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
    @State private var showDetailView: Bool = false
    @State private var isPresented: Bool = false
    @StateObject private var searchCompleter = SearchCompleter()
    @FocusState private var isSearchFocused: Bool
    @FocusState private var isOverlaySearchFocused: Bool
    @State private var offsetY: CGFloat = 0
    @State private var selectedPlaceID: UUID?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismissSheet
    @Namespace private var animationID
    @State private var expandedItem: IssueMarker?
    @Environment(\.dismiss) private var dismiss
    @State private var issues: [IssueMarker] = []
    
    private let animation = Animation.easeInOut(duration: 0.25)
    
    
    var progress: CGFloat {
        return max(min(offsetY / 100, 1), 0)
    }
    
    private var filteredIssues: [IssueMarker] {
        issues.filter { selectedStatuses.contains($0.status) }
    }
    
    var body: some View {
        MapReader { proxy in
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(filteredIssues) { issue in
                        Annotation(issue.title, coordinate: issue.coordinate) {
                            AnnotationView(issue)
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
                .contentMargins(.bottom, 90, for: .scrollContent)
                .onMapCameraChange(frequency: .onEnd) { context in
                    handleMapMovement(center: context.camera.centerCoordinate)
                }
                
                bottom
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
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
            searchCompleter.update(query: newValue, region: currentRegion(c: cameraPosition))
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
        .sheet(item: $expandedItem) { issue in
            DetailView(issue: issue)
                .navigationTransition(.zoom(sourceID: issue.id, in: animationID))
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
                            
                            SuggestionsResultList(searchText: $searchText, searchCompleter: searchCompleter, applySuggestion: { suggestion in
                                applySuggestion(suggestion)
                            })
                        }
                        .onAppear {
                            isOverlaySearchFocused = true
                        }
                    }
                    .zIndex(10)
            }
            
        }
        .toolbar(showSearchOverlay ? .hidden : .visible, for: .tabBar)
        .onAppear {
            showSearchOverlay = false
            
            Task {
                issues = await ReportRepository.list()
            }
        }
    }
    
    private var bottom: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: colorScheme == .dark ? .black.opacity(0.1) : .white.opacity(0.1), location: 0.5),
                        .init(color: colorScheme == .dark ? .black.opacity(0.9) : .white.opacity(0.9), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .blur(radius: 30, opaque: false)
            .frame(height: 225)
            .allowsHitTesting(false)
    }
    
    private func handleMapMovement(center: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        Task {
            guard let request = MKReverseGeocodingRequest(location: location) else { return }
            let mapItems = try? await request.mapItems
            guard let mapItem = mapItems?.first else { return }
            
            let country = mapItem.addressRepresentations?.region?.identifier
            ?? mapItem.addressRepresentations?.regionName
            ?? "-1"
            
            let cityName = mapItem.addressRepresentations?.cityName ?? "-1"
            
            print(country)
            print(cityName)
        }
    }
    
    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = currentRegion(c: cameraPosition)
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.location.coordinate
            searchMarker = IssueMarker(title: item.name ?? String(localized: "Result"), status: .reported, coordinate: coordinate, issueType: .all)
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
        request.region = currentRegion(c: cameraPosition)
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.location.coordinate
            searchMarker = IssueMarker(title: item.name ?? String(localized: "Result"), status: .reported, coordinate: coordinate, issueType: .all)
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
    
    private func centerMapOnUserLocation() {
        locationManager.requestAuthorization()
        guard let location = locationManager.lastLocation else { return }
        hasCenteredOnUser = true
        cameraPosition = .region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.0082, longitudeDelta: 0.0082)
                
            )
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
                centerMapOnUserLocation()
            } label: {
                Image(systemName: "location")
            }
        }
        .font(.title3)
        .foregroundStyle(Color.primary)
        .padding(.vertical, 55)
        .padding(.horizontal, 16)
    }
    
    
    @ViewBuilder
    private func AnnotationView(_ issue: IssueMarker) -> some View {
        let isSelected = issue.id == selectedPlaceID
        
        
        Image(systemName: issue.issueType.iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.black)
            .padding(isSelected ? 8 : 3)
            .frame(width: isSelected ? 50 : 20, height: isSelected ? 50 : 20)
            .background {
                Circle()
                    .fill(.white)
                    .padding(-1)
            }
            .animation(animation, value: isSelected)
            .background {
                if isSelected {
                    PulseRingView(tint: issue.status.color, size: 80)
                }
            }
            .contentShape(.rect)
            .onTapGesture {
                expandedItem = issue
                showDetailView.toggle()
                withAnimation(animation) {
                    selectedPlaceID = issue.id
                }
            }
    }
}

struct IssueMarker: Identifiable {
    let id = UUID()
    let title: String
    let status: IssueStatus
    let coordinate: CLLocationCoordinate2D
    let issueType: IssueTypes
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

private struct StatusFilterRow: View {
    @Binding var selectedStatuses: Set<IssueStatus>
    @State private var issueType: IssueTypes = .all
    
    var body: some View {
        
        HStack {
            
            Group {
                //                Picker(selection: $issueType) {
                //                    ForEach(IssueTypes.allCases, id: \.self) { issueType in
                //                        Text(issueType.title).tag(issueType)
                //                    }
                //                } label: {
                //                    Image(systemName: "line.3.horizontal.decrease")
                //                        .fontWeight(.semibold)
                //                        .foregroundStyle(.primary)
                //                        .transition(.blurReplace)
                //                        .frame(width: 24, height: 24)
                //                }
                //                .pickerStyle(.menu)
                //                .buttonStyle(.glass)
                //                .buttonBorderShape(.circle)
                
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
                            .sensoryFeedback(.selection, trigger: isSelected)
                        }
                        .accessibility(identifier: "statusFilterButtons")
                    }
                }
                .scrollClipDisabled()
                //                .frame(width: 300)
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
