//
//  LocatorView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/3/26.
//

import SwiftUI

struct LocatorView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Button("Find by City") {
            findByCity()
        }
        .padding()
        .buttonStyle(.bordered)
        
        Button("Find by city id") {
            findCityById()
        }
        .padding()
        .buttonStyle(.bordered)
    }
    
    private func findByCity() {
        let details = LocatorDAO.shared.findBy(countryCode: "SV", cityName: "San Salvador")
        print(details.cityId)
    }
    
    private func findCityById() {
        let details = LocatorDAO.shared.findBy(countryCode: "SV", cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619")
        print(details.groupingName)
    }
}

#Preview {
    LocatorView()
}
