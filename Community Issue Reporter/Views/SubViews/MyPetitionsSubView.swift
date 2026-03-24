//
//  MyPetitionsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct MyPetitionsSubView: View {
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
    MyPetitionsSubView(subViewName: "My Petitions")
}
