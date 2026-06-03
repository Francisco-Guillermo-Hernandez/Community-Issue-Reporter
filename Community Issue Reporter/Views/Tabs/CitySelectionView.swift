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
            
            if city.isCapitalCity == 1 {
                Text("Is the capital of \(city.firstLevel)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text(city.legalGroupName)
                .font(.caption)
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            if city.groupingName != nil && city.groupingName != "" {
                Text(city.groupingName ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
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
    @State private var page: Int = 1
    @State private var friendlyCities: FriendlyCities = .init(
        documents: [],
        hasNext: false,
        hasPrev: false
    )
    @State private var searchText: String = ""
    @State private var isLoading: Bool = false
    @State private var isSearchActive: Bool = false
    @State private var searchOptionsSelection: CityFilter = .city

    @State private var triggerFeedBack: Bool = false
    
    var countryCode: CountryCode
    var mode: CitySelectionMode = .step
    @Binding var selectedCity: FriendlyCityDistribution
    var nextStep: () -> Void


    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: .themeSpacing * 4) {

                    if isLoading {
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                    }

                    if cities.isEmpty && !isLoading {
                        /// No content state
                        noContent
                    } else {
                        
                        ForEach(cities,id: \.self.cityId) { city in
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
                text: $searchText,
                isPresented: $isSearchActive,
                placement: .navigationBarDrawer,
                prompt: String(localized: "Search a city")
            )
            .safeAreaInset(edge: .bottom, spacing: 0) {

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
                        ThemedButton(
                            message: buttonMessage,
                            action: {
                                triggerFeedBack.toggle()
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
                    .frame(maxWidth: .infinity)
                }
                .fixedSize(horizontal: false, vertical: true)

            }
            .sensoryFeedback(
                .impact(weight: .medium),
                trigger: triggerFeedBack
            )
            .task {
                // Invoke the repository at first
                isLoading = true
                friendlyCities = CitiesRepository.shared.loadLocalCities(
                    of: countryCode,
                )
                isLoading = false
            }
            .onChange(of: searchText) {
                Task {
                    try? await Task.sleep(for: .milliseconds(450))
                    if searchOptionsSelection == .legal { await fetchCitiesByGroupingName() }
                    if searchOptionsSelection == .city  { await fetchByCityName() }
                    if searchOptionsSelection == .state { await fetchCitiesByStateName() }
                }
            }
            .onChange(of: searchOptionsSelection) { oldValue, newValue in

                if oldValue != newValue {
                    if newValue.rawValue == "legal" {
                        searchText = "Municipio de "
                    } else {
                        searchText = ""
                    }

                    isSearchActive = true

                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    // Menu to filter cities by its options
                    Menu {
                        Picker("Options", selection: $searchOptionsSelection) {

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

    private var cities: [FriendlyCityDistribution] {
        guard  let friendlyCities = friendlyCities.documents else { return [] }
        let result = friendlyCities.sorted { $0.isCapitalCity ?? 0 > $1.isCapitalCity ?? 0 }
        return result
    }


    private func fetchCitiesByGroupingName() async {
        isLoading = true
        friendlyCities =
            await CitiesRepository
            .shared
            .filter(
                countryCode: countryCode.rawValue,
                page: page,
                groupingName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            )

        isLoading = false
    }

    private func fetchCitiesByStateName() async {
        isLoading = true
        friendlyCities =
            await CitiesRepository
            .shared
            .filter(
                countryCode: countryCode.rawValue,
                page: page,
                stateName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        isLoading = false
    }

    private func fetchByCityName() async {
        isLoading = true
        friendlyCities =
            await CitiesRepository
            .shared
            .filter(
                countryCode: countryCode.rawValue,
                page: page,
                cityName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        isLoading = false
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
    } actions: {
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
    CitySelectionView(countryCode: countryCode, selectedCity: $sanSalvador, nextStep: {
        
    })
}
