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
    }
    
    private func findByCity() {
        let dao = LocatorDAO()
        let details = dao.findBy(cityName: "San Salvador")
        print(details)
    }
}

#Preview {
    LocatorView()
}
