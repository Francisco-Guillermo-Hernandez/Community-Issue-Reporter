//
//  SignedPetitionsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct SignedPetitionsSubView: View {
    var subViewName: String
    var body: some View {
        NavigationStack {
            Text("Hello")
        }
        .navigationTitle(subViewName)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    SignedPetitionsSubView(subViewName: "Signed Petitions")
}
