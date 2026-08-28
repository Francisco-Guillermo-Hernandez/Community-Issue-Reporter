//
//  MapExplorerView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import CoreLocation
import MapKit
import Observation
import SwiftUI
internal import Combine

struct MapExplorerView: View {
    @Namespace private var profileNamespace
    @Namespace private var searchPlacesNamespace
    @Namespace private var animationID
    @EnvironmentObject var appState: AuthViewModel
    @Environment(SettingsStore.self) var settings
    @State private var profile = ProfileDataModel()
    
    @State private var controller = MapExplorerController.shared
    @State private var searchCompleter = SearchCompleter()
    @FocusState private var isSearchFocused: Bool
    @FocusState private var isOverlaySearchFocused: Bool
    @State private var offsetY: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismissSheet
    @Environment(\.dismiss) private var dismiss
    @State private var router = DeepLinkRouter.shared
    @State private var showLocationAlert = false
    @State private var monetizationManager = MonetizationManager.shared
    
    private let animation = Animation.easeInOut(duration: 0.25)
    
    var progress: CGFloat {
        return max(min(offsetY / 100, 1), 0)
    }
    
    var body: some View {
        @Bindable var controller = controller
        MapReader { proxy in
            ZStack(alignment: .bottom) {
                Map(position: $appState.cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(controller.reports) { report in
                        Annotation(report.title, coordinate: report.clLocation) {
                            annotationView(report)
                        }
                    }
                    
                    if let searchMarker = controller.searchMarker {
                        Marker(searchMarker.title, coordinate: searchMarker.coordinate)
                    }
                }
                .contentMargins(.leading, 32, for: .scrollContent)
                .contentMargins(.bottom, 90, for: .scrollContent)
                .onMapCameraChange(frequency: .onEnd) { context in
                   
                    controller.handleMapMovement(center: context.camera.centerCoordinate)
                    
                    // Store the span in UserDefaults when the user zooms
                    UserDefaults.standard.set(context.region.span.latitudeDelta, forKey: "map_latitude_delta")
                    UserDefaults.standard.set(context.region.span.longitudeDelta, forKey: "map_longitude_delta")
                    
                    if settings.saveLastLocation {
                        appState.updateLastLocation(
                            latitude: context.camera.centerCoordinate.latitude,
                            longitude: context.camera.centerCoordinate.longitude
                        )
                    }
                }
                
                bottom
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 16) {
//                Text("Repórtamelo")
//                    .font(.custom("Lora", size: 16, relativeTo: .title))
//                    .padding(.top, 16)
//                    .padding(.horizontal)
//                    .kerning(0.6)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                CustomTabBar(
                    items: controller.searchItems,
                    searchHint: String(localized: "Reports, Petitions, Places..."),
                    selection: $controller.selection,
                    searchText: $controller.searchText,
                    isSearchExpanded: $controller.isSearchExpanded,
                    onSearchActivated: {_ in },
                    onLocationTap: {
                        let status = controller.locationManager.manager.authorizationStatus
                        if status == .denied || status == .restricted {
                            showLocationAlert = true
                        } else {
                            controller.centerMapOnUserLocation()
                        }
                    }
                )
                .zIndex(30)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onChange(of: controller.searchText) { _, newValue in
            let pattern = "^[a-zA-Z]{2}-[a-zA-Z]{2,3}-\\d{8}-[a-zA-Z0-9]{16}$"
            if newValue.range(of: pattern, options: .regularExpression) != nil {
                Task {
                    await controller.searchReport(by: newValue)
                }
            } else {
                controller.searchedReportOverview = nil
                searchCompleter.update(query: newValue, region: currentRegion(c: appState.cameraPosition))
            }
        }
        .task {
            await appState.checkStatus()
            await SubscriptionManager.shared.performLogin()
            monetizationManager.requestTrackingAuthorization()
        }
        .onChange(of: controller.locationManager.lastLocation) { _, newLocation in
            // Handled or observed if needed
        }
        .fullScreenCover(isPresented: $controller.showUserProfileOverlay) {
            UserProfileView()
        }
        .sheet(item: $controller.expandedItem) { report in
            DetailView(report: report)
        }
        .sheet(isPresented: $router.isPresented) {
            DetailView(report: router.report)
                .skeleton(isRedacted: router.isLoading)
        }
        .overlay {
            ZStack {
                if controller.isSearchExpanded {
                    if let report = controller.searchedReportOverview {
                        ReportOverviewList(report: report, controller: controller, router: router)
                            .background(
                                Color.clear
                                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: .themeRadius * 2))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2))
                            .padding()
                            .padding(.top, 64)
                            .transition(.scale(scale: 0.95, anchor: .top).combined(with: .opacity))
                            .frame(maxHeight: 450, alignment: .top)
                            .shadow(color: Color.black.opacity(0.125), radius: 16, x: 0, y: 6)
                    } else {
                        SuggestionsResultList(searchText: $controller.searchText, searchCompleter: searchCompleter, applySuggestion: { suggestion in
                            controller.applySuggestion(suggestion)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                controller.isSearchExpanded = false
                            }
                        })
                        .background(
                            Color.clear
                                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: .themeRadius * 2))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2))
                        .padding()
                        .padding(.top, 64)
                        .shadow(color: Color.black.opacity(0.125), radius: 16, x: 0, y: 6)
                        .transition(.scale(scale: 0.95, anchor: .top).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: controller.isSearchExpanded)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: controller.searchedReportOverview != nil)
        }
        .toolbar(controller.showSearchOverlay ? .hidden : .visible, for: .tabBar)
        .task {
            guard !Task.isCancelled else { return }
            controller.authViewModel = appState
            controller.settings = settings
            await controller.loadReports()
        }
        .alert(String(localized: "Location Permission"), isPresented: $showLocationAlert) {
            Button(String(localized: "Settings"), role: .cancel) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button(String(localized: "Cancel"), role: .destructive) {}
        } message: {
            Text(String(localized: "Please enable location permissions in settings."))
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
    
    @ViewBuilder
    private func placesOverlay(p profileNamespace: Namespace.ID, controller: MapExplorerController) -> some View {
        @Bindable var controller = controller
        Rectangle()
            .fill(.ultraThinMaterial)
            .background(.background.opacity(0.25))
            .ignoresSafeArea()
            .overlay {
                VStack {
                    SearchBar(
                        text: $controller.searchText,
                        onSubmit: {
                            controller.performSearch()
                            controller.showSearchOverlay = false
                        },
                        onFocusChange: { isFocused in
                            controller.showSearchOverlay = isFocused
                        },
                        onUserProfileTap: {},
                        isFocused: $isOverlaySearchFocused,
                        profileNamespace: profileNamespace,
                        avatarURL: profile.avatarURL
                    )
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 10)
                    
                    SuggestionsResultList(searchText: $controller.searchText, searchCompleter: searchCompleter, applySuggestion: { suggestion in
                        controller.applySuggestion(suggestion)
                    })
                }
                .task {
                    try? await Task.sleep(for: .milliseconds(75))
                    isOverlaySearchFocused = true
                }
            }
            .zIndex(10)
    }
    
    @ViewBuilder
    private func BottomFloatingToolBar(controller: MapExplorerController) -> some View {
        VStack(spacing: 35) {
            Button {
                
            } label: {
                Image(systemName: "car.fill")
            }
            
            Button {
                controller.centerMapOnUserLocation()
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
    private func annotationView(_ issue: MapExplorerReport) -> some View {
        let isSelected = issue.id == controller.selectedPlaceID
        
        Image(systemName: issue.issueType.iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.black)
            .padding(isSelected ? 8 : 3)
            .frame(width: isSelected ? 50 : 28, height: isSelected ? 50 : 28)
            .background {
                Circle()
                    .stroke(Color.theme.inputBorder.opacity(0.4), lineWidth: 2)
                    .fill(.white)
//                    .padding(-1)
            }
            .animation(animation, value: isSelected)
            .background {
                if isSelected {
                    PulseRingView(tint: issue.status.color, size: 80)
                }
            }
            .frame(minWidth: 44, minHeight: 44)
//                .contentShape(Rectangle())
            .contentShape(.rect)
            .onTapGesture {
                controller.expandedItem = issue
                withAnimation(animation) {
                    controller.selectedPlaceID = issue.id
                }
            }
    }
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

// MARK - Custom badges to filter over the map
private struct StatusFilterRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedStatuses: Set<IssueStatus>
    @State private var issueType: IssueTypes = .all
    
    
    var body: some View {
        HStack {
            Group {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(IssueStatus.allCases) { status in
                            let isSelected = selectedStatuses.contains(status)
                            Button {
                                toggle(status)
                            } label: {
                                HStack {
                                    Image(systemName: status.iconName)
                                        .foregroundStyle(status.color)
                                    
                                    Text(LocalizedStringKey(status.title))
                                        .foregroundStyle(status.color)
                                        .font(.subheadline.weight(.semibold))
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? (colorScheme != .dark ? .white : .black) : .primary )
//                                        .brightness(-0.2)
                                )
                                .glassEffect(.regular.interactive(), in: .capsule)
                            }
                            .sensoryFeedback(.selection, trigger: isSelected)
                        }
                        .accessibility(identifier: "statusFilterButtons")
                    }
                }
                .scrollClipDisabled()
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

private struct ReportOverviewList: View {
    let report: MapExplorerReport
    let controller: MapExplorerController
    let router: DeepLinkRouter
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                DetailsHeader(title: report.title, description: report.description)
                
                BasicInformationView(for: report)
                
                Button {
                    Task {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            controller.isSearchExpanded = false
                        }
                        try? await Task.sleep(for: .milliseconds(128))
                        
                        await MainActor.run {
                            router.report = report
                            router.activeTab = 1
                            router.isPresented = true
                        }
                    }
                } label: {
                    Text(String(localized: "Show more details"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding(.vertical, 10)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        MapExplorerView()           
            .environmentObject(AuthViewModel())
            .environment(DeepLinkRouter())
            .environment(SettingsStore())
    }
}
