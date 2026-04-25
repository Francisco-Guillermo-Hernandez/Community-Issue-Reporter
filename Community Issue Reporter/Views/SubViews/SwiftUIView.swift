//
//  SwiftUIView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/4/26.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var date = Date()
    var body: some View {
        List {
            DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
        }
    }
}

#Preview {
    SwiftUIView()
}
