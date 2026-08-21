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
            Group {
                GeometryReader { geometry in
                    let scrollViewFrame = geometry.frame(in: .local)
                    
                    
                    ScrollView {
                        
                        
                        ForEach(Array(controller.cities.enumerated()), id: \.offset) { offset, city in
                            RowContentBoth(offset: offset, scrollViewFrame: scrollViewFrame, city: city, isSelected: selectedCity.cityId == city.cityId)
                                .onTapGesture {
                                    selectedCity = city
                                }
                                .sensoryFeedback(
                                    .impact(weight: .light, intensity: 0.5),
                                    trigger: selectedCity.cityId == city.cityId
                                )
                                .padding(.bottom, 4)
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.theme.background)
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
                            controller.updateCity(city: selectedCity) {
                                
                                nextStep()
                                if mode == .modify {
                                    dismiss()
                                }
                            }
                            
                            controller.triggerFeedBack.toggle()
                        },
                        type: .primary,
                        isLoading: $controller.isLoading
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
    @State var sanSalvador: FriendlyCityDistribution = SelectedMockedCity.shared.city
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

// MARK: -

//struct ScrollingStackDemoBoth: View {
//    var body: some View {
//        
//        GeometryReader { geometry in
//            let scrollViewFrame = geometry.frame(in: .local)
//            
//            
//            ScrollView {
//                
//                
//                
//                ForEach(0..<100) { offset in
//                    RowContentBoth(offset: offset, scrollViewFrame: scrollViewFrame, )
////                        .cellStyle() /// Apply custom style
//                }
//                .padding(.horizontal)
//            }
//        }
//        .background(Color.theme.background)
//    }
//}

//

private struct RowContentBoth: View {
    let offset: Int
    let scrollViewFrame: CGRect
    let city: FriendlyCityDistribution
    let isSelected: Bool
    @State var zIndex: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
           
            .fill(Color.theme.cardBackground)
            .frame(height: 90.0)
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                    .stroke(Color.theme.border, lineWidth: 1)
            )
            .overlay {
                CityCellView(city: city)
                    .padding()
            }
            .overlay {
                if isSelected {
                        RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                            .stroke(Color.theme.primary.opacity(0.65), lineWidth: 4)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
            .glassEffect( in: RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous))
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .scrollView) } action: { newValue in
                zIndex = min(newValue.minY, min(scrollViewFrame.midY - newValue.midY, 0))
            }
            .zIndex(zIndex * Double(offset))
            .visualEffect { content, proxy in
                let frame = proxy.frame(in: .scrollView(axis: .vertical))
                let distance1 = frame.minY
                let distance2 = scrollViewFrame.maxY - frame.maxY
                let distance = min(distance1, min(distance2, 0))
                return content
//                    .hueRotation(.degrees(frame.origin.y / 5))
                    .scaleEffect(max(1 + distance / 1000, 0))
                    .offset(y: distance1 < 0 ? -distance : distance)
//                    .brightness(distance1 < 0 ? -distance / 500 : -distance / 200)
            }
        
    }
}
//
//#Preview("Both edge") {
//    ScrollingStackDemoBoth()
//}
