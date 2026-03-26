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
                
                Rectangle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black.opacity(0.1), location: 0.5),
                                    .init(color: .black.opacity(0.6), location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        .frame(height: 125)
                        .allowsHitTesting(false)
                
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
        .sheet(item: $expandedItem) { issue in
            DetailView(onDismiss: {
                showDetailView = false
                dismiss()
            }, issue: issue)
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
                            
                            List {
                                let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if trimmed.isEmpty {
                                    Text(String(localized: "Start typing to search."))
                                } else if searchCompleter.suggestions.isEmpty {
                                    ContentUnavailableView.search(text: String(localized: "No matches found."))
                                } else {
                                    ForEach(searchCompleter.suggestions) { suggestion in
                                        Button {
                                            applySuggestion(suggestion)
                                        } label: {
                                            HStack(spacing: 8) {
                                                Image(systemName: "mappin")
                                                    .frame(width: 32, height: 32)
                                                    .clipShape(Circle())
                                                    .background(.thinMaterial, in: .circle)
                                                    .transition(.blurReplace)
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(suggestion.title)
                                                        .fontWeight(.semibold)
                                                        .font(.title3)
                                                
                                                    if !suggestion.subtitle.isEmpty {
                                                        Text(suggestion.subtitle)
                                                            .font(.caption)
                                                            
                                                    }
                                                }
                                            }
                                            
                                            .padding(.vertical, 6)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
//                            .clipped()
                        }
                        .onAppear {
                            isOverlaySearchFocused = true
                        }
                    }
            }

        }
//        .toolbar(showSearchOverlay ? .hidden : .visible, for: .tabBar)
        .onAppear {
            Task {
                issues = await ReportRepository.list()
            }
        }
//        .transition(.scale(scale: 0, anchor: .top).combined(with: .opacity))
       
//        .animation(.easeInOut(duration: 0.25), value: showSearchOverlay)
//        .overlay(alignment: .bottom) {
//            Group {
//                if #available(iOS 26, *) {
//                    CustomAlert(message: "Hi")
//                     
////                    BottomFloatingToolBar()
////                        .glassEffect(.regular, in: .capsule)
//                }
//            }
//            .offset(x: 0, y: -22)
//        }
        
        
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
            
        
            print("\n")
      
            
            print(country)
            print(cityName)
        }
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = currentRegion()

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
        request.region = currentRegion()

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

private struct StatusFilterRow: View {
    @Binding var selectedStatuses: Set<IssueStatus>
    @State private var issueType: IssueTypes = .all

    var body: some View {
        
        HStack {
        
            Group {
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
                            .sensoryFeedback(.selection, trigger: isSelected)
                        }
                        .accessibility(identifier: "statusFilterButtons")
                    }
                }
                .scrollClipDisabled()
                .frame(width: 300)
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

fileprivate struct DetailView: View {
    let onDismiss: () -> Void
    var issue: IssueMarker
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(issue.title)
                    .font(.subheadline)
                    .bold()
            }
            .toolbar {
                
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Close", systemImage: "xmark") {
//                        onDismiss()
//                    }
//                }
                
                ToolbarItem(placement: .title) {
                    Text(issue.title)
                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem() {
                    ShareLink(item: "") {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            
        }
        .presentationDetents([.medium, .fraction(0.2)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    ReportsView()
}
