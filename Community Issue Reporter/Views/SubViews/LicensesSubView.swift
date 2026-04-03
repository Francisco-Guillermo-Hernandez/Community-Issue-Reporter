//
//  LicencesSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct LicensesSubView: View {
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
    LicensesSubView(subViewName: "Licences")
}
