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
    
    @State private var controller = MapExplorerController()
    @State private var searchCompleter = SearchCompleter()
    @FocusState private var isSearchFocused: Bool
    @FocusState private var isOverlaySearchFocused: Bool
    @State private var offsetY: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismissSheet
    @Environment(\.dismiss) private var dismiss
    @State private var router = DeepLinkRouter.shared
    
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
                .contentMargins(.bottom, 90, for: .scrollContent)
                .onMapCameraChange(frequency: .onEnd) { context in
                    print("all context")
                    dump(context)
                    controller.handleMapMovement(center: context.camera.centerCoordinate)
                    
                    // Store the span in UserDefaults when the user zooms
                    UserDefaults.standard.set(context.region.span.latitudeDelta, forKey: "map_latitude_delta")
                    UserDefaults.standard.set(context.region.span.longitudeDelta, forKey: "map_longitude_delta")
                }
                
                bottom
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 16) {
                SearchBar(
                    text: $controller.searchText,
                    onSubmit: {
                        controller.performSearch()
                        controller.showSearchOverlay = false
                    },
                    onFocusChange: { isFocused in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            controller.showSearchOverlay = isFocused
                        }
                    },
                    onUserProfileTap: {
                        controller.showUserProfileOverlay.toggle()
                    },
                    isFocused: $isSearchFocused,
                    profileNamespace: profileNamespace,
                    avatarURL: profile.avatarURL
                )
                
                StatusFilterRow(selectedStatuses: $controller.selectedStatuses)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onChange(of: controller.searchText) { _, newValue in
            searchCompleter.update(query: newValue, region: currentRegion(c: appState.cameraPosition))
        }
        .task {
            await appState.checkStatus()
            
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
            if controller.showSearchOverlay {
                placesOverlay(p: profileNamespace, controller: controller)
            }
        }
        .toolbar(controller.showSearchOverlay ? .hidden : .visible, for: .tabBar)
        .task {
//            controller.showSearchOverlay = false
        }
        .task {
            guard !Task.isCancelled else { return }
            controller.authViewModel = appState
            controller.settings = settings
            await controller.loadReports()
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

#Preview {
    NavigationStack {
        MapExplorerView()
           
            .environmentObject(AuthViewModel())
            .environment(DeepLinkRouter())
            .environment(SettingsStore())
    }
}
