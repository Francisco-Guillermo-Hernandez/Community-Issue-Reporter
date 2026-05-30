//
//  LandingView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/5/26.
//

import SwiftUI

struct LandingView: View {
    @State private var path = [String]()
    @State private var selectedCity: FriendlyCityDistribution = .init(
                        cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
                        firstLevel: "",
                        secondLevel: "",
                        thirdLevel: "",
                        ZipCode: "",
                        legalGroupName: "",
                        coordinates: .init(lat: 0, lng: 0),
                        isCapitalCity: 0,
                        isDepartmentalCapital: 0)
    var countryCode: String = "SV"
    var body: some View {
        NavigationStack(path: $path) {
            CitySelectionView(countryCode: countryCode, selectedCity: $selectedCity,  nextStep: {
                
            })
        }
    }
}

#Preview {
    LandingView()
}
