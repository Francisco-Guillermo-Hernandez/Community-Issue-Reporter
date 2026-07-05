//
//  CustomCard.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/6/26.
//

import SwiftUI




struct CustomCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 5) {
            VStack {
                ThemedButton(message: "Hello", action: {
                    print("hello world")
                }, type: .outline)
            }
        }
        .padding()
        .customCardStyle()
        
    }
}

#Preview {
    ZStack {
        Color.theme.background
            .ignoresSafeArea(edges: .all)
        CustomCard()
    }
}
