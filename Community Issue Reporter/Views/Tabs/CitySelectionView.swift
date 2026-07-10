//
//  CitySelectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/5/26.
//

import SwiftUI

enum CitySelectionMode: String {
    case modify
    case step
}

// MARK: - Cell View
struct CityCellView: View {
    let city: FriendlyCityDistribution
    var body: some View {
        VStack {

            Text(city.thirdLevel)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .kerning(0.2)
            
            if city.isCapitalCity == 1 {
                Text("Is the capital of \(city.firstLevel)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text(city.legalGroupName)
                .font(.caption)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if city.groupingName != nil && city.groupingName != "" {
                Text(city.groupingName ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

        }
        .padding(.vertical, .themeSpacing)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - View
struct CitySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var controller: CitySelectionController
    
    var mode: CitySelectionMode = .step
    @Binding var selectedCity: FriendlyCityDistribution
    var nextStep: () -> Void

    init(countryCode: CountryCode, mode: CitySelectionMode = .step, selectedCity: Binding<FriendlyCityDistribution>, nextStep: @escaping () -> Void) {
        self.mode = mode
        self._selectedCity = selectedCity
        self.nextStep = nextStep
        self.controller = CitySelectionController(countryCode: countryCode)
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: .themeSpacing * 4) {

                    if controller.cities.isEmpty && !controller.isLoading {
                        /// No content state
                        noContent
                    } else {
                        
                        ForEach(controller.cities, id: \.self.cityId) { city in
                            Button {
                                selectedCity = city
                            } label: {
                                CityCellView(city: city)
                                    .cellStyle() /// Apply custom style
                                    .overlay {
                                        /// Provides a visual feedback about what element is selected
                                        RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                                            .stroke(
                                                selectedCity.cityId == city.cityId ?
                                                Color.theme.primary.opacity(0.65) : .clear, lineWidth: 2
                                            )
                                    }
                            }
                            .sensoryFeedback(
                                .impact(weight: .light, intensity: 0.5),
                                trigger: selectedCity.cityId == city.cityId
                            )
                        }
                        
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Select a city")
            .background(Color.theme.background)
            .searchable(
                text: $controller.searchText,
                isPresented: $controller.isSearchActive,
                placement: .navigationBarDrawer,
                prompt: String(localized: "Search a city")
            )
            .safeAreaInset(edge: .bottom, spacing: 0) {

                BottomFadedView {
                    ThemedButton(
                        message: buttonMessage,
                        action: {
                            controller.triggerFeedBack.toggle()
                            nextStep()
                            
                            if mode == .modify {
                                dismiss()
                            }
                        },
                        type: .primary
                    )
                    .padding()
                    .padding(.top, 0)
                }

            }
            .sensoryFeedback(
                .impact(weight: .medium),
                trigger: controller.triggerFeedBack
            )
            .task {
                controller.loadLocalCities()
            }
            .onChange(of: controller.searchText) {
                Task {
                    await controller.performSearch()
                }
            }
            .onChange(of: controller.searchOptionsSelection) { oldValue, newValue in
                controller.handleSearchOptionsSelectionChange(from: oldValue, to: newValue)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    // Menu to filter cities by its options
                    Menu {
                        Picker("Options", selection: $controller.searchOptionsSelection) {

                            ForEach(CityFilter.allCases, id: \.self) { filter in
                                Text(filter.text).tag(filter)
                            }
                        }
                    } label: {
                        Label(
                            "Options",
                            systemImage: "line.3.horizontal.decrease"
                        )
                    }
                }
            }
        }
    }
    
    private var buttonMessage: String {
        if mode == .modify {
            return String(
                localized: "Select a city", 
                comment: "Update city"
            )
        } else {
            return String(
               localized: "Next Step",
               comment: "Next Step at select city view"
           )
        }
    }

    let noContent: some View = ContentUnavailableView {
        Label(
            "There are no cities that match with your search.",
            systemImage: "map"
        )
        .symbolRenderingMode(.palette)
        .foregroundStyle(
            Color.theme.foreground.opacity(0.7),
            Color.theme.primary,
            Color.theme.foreground.opacity(0.7)
        )
    } description: {
        Text("Please, write a city name")
    }
    .containerRelativeFrame(.vertical)
}


// MARK: - Preview
#Preview {
    
    @Previewable
    @State var sanSalvador: FriendlyCityDistribution = .init(
        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
        firstLevel: "El Salvador",
        secondLevel: "San Salvador",
        thirdLevel: "San Salvador",
        ZipCode: "1101",
        legalGroupName: "Distrito de San Salvador",
        coordinates: .init(lat: 13.701270, lng: -89.224432),
        isCapitalCity: 1,
        isDepartmentalCapital: 1
    )
    let countryCode: CountryCode = .SV
    
    NavigationStack {
        CitySelectionView(countryCode: countryCode, selectedCity: $sanSalvador, nextStep: {
            
        })
    }
}

struct BottomFadedView<Content: View>: View {
    
    let content: Content
    init (@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }
                .ignoresSafeArea()

            VStack {
                content
            }
            .frame(maxWidth: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
