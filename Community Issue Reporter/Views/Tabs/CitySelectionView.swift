//
//  CitySelectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 23/5/26.
//

import SwiftUI



struct CityCellView: View {
    let city: FriendlyCityDistribution
    var body: some View {
        VStack {

            
            Text(city.thirdLevel)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

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
            
            if city.isCapitalCity == 1 {
                Text("Is the capital of")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }

        }
        .padding(.vertical, .themeSpacing)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CitySelectionView: View {
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
    @State private var selectedCity: FriendlyCityDistribution?
    
    var nextStep: () -> Void

    
    init(nextStep: @escaping () -> Void ) {
        
        self.nextStep = nextStep
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "CardForeground")! ]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "CardForeground")!]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }


    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: .themeSpacing * 4) {

                    if isLoading {
                        ProgressView()
                            .containerRelativeFrame(.vertical)
                    }

                    if cities.isEmpty && !isLoading {
                        ContentUnavailableView {
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
                    } else {
                        ForEach(
                            friendlyCities.documents ?? [],
                            id: \.self.cityId
                        ) { city in
                            Button {
                                selectedCity = city
                            } label: {
                                CityCellView(city: city)
                                    .cellStyle()
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                                            .stroke(
                                                selectedCity?.cityId == city.cityId ?
                                                Color.theme.secondary : .clear, lineWidth: 2
                                            )
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbarTitleDisplayMode(.inlineLarge)
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
                            message: String(
                                localized: "Next Step",
                                comment: "Next Step at select city view"
                            ),
                            action: {},
                            type: .secondary
                        )
                        .padding()
                        .padding(.top, 0)
                    }
                    .frame(maxWidth: .infinity)
                }
                .fixedSize(horizontal: false, vertical: true)

            }
            .task {
                isLoading = true
                friendlyCities = await CitiesRepository.shared.filter(
                    countryCode: "SV",
                    page: page,
                    departmentalCapital: true,
                )
                isLoading = false
            }
            .onChange(of: searchText) {
                Task {
                    try? await Task.sleep(for: .milliseconds(550))
                    if searchOptionsSelection == .legal {
                        await fetchCitiesByGroupingName()
                    }

                    if searchOptionsSelection == .city {
                        await fetchByCityName()
                    }

                    if searchOptionsSelection == .state {
                        await fetchCitiesByStateName()
                    }
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
                    
                    Menu {
                        Picker("Options", selection: $searchOptionsSelection) {

                            ForEach(CityFilter.allCases, id: \.self) { city in
                                Text(city.text).tag(city.rawValue)
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

//    private var cities: [FriendlyCityDistribution] {
//        var k: [FriendlyCityDistribution] = friendlyCities.documents ?? []
//        
//        var result = k.sort { !$0.isCapital && !$1.isCapital}
//      return result
//
//    }
    
    
    private var cities: [FriendlyCityDistribution] {
        guard  let ci = friendlyCities.documents else {
            return []
        }
        

        let result = ci.sorted { $0.isCapitalCity ?? 0 > $1.isCapitalCity ?? 0 }
        return result
    }


    private func fetchCitiesByGroupingName() async {
        isLoading = true
        friendlyCities =
            await CitiesRepository
            .shared
            .filter(
                countryCode: "SV",
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
                countryCode: "SV",
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
                countryCode: "SV",
                page: page,
                cityName: searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        isLoading = false
    }
}

#Preview {
    CitySelectionView(nextStep: {
        
    })
}
