//
//  DetailsHeader.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/6/26.
//

import SwiftUI

struct DetailsHeader: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack {
           Text(title)
               .font(.title2)
               .bold()
               .fontWidth(.condensed)
               .fontWeight(.bold)
               .lineLimit(1)
               .kerning(0.6)
               .frame(maxWidth: .infinity, alignment: .leading)

           Text(description)
               .font(.subheadline)
               .opacity(0.85)
               .lineLimit(1)
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding(.leading, .themePadding)
       }
    }
}

#Preview {
    DetailsHeader(title: "Hello", description: "world")
}
