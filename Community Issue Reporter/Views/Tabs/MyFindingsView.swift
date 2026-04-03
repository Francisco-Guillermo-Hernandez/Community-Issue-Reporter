//
//  MyFindingsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI

struct MyFindingsView: View {
   
    @State private var selectedOption: String = "My Reports"
    
    let options: [String] = ["My Reports", "My Petitions", "Signed Petitions"]
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Options", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 32)
                
                ScrollView(.vertical) {
                    switch selectedOption {
                    case "My Reports":
                        MyReportsSubView(subViewName: selectedOption)
                    case "My Petitions":
                        MyPetitionsSubView(subViewName: selectedOption)
                    case "Signed Petitions":
                        SignedPetitionsSubView(subViewName: selectedOption)
                    default:
                        MyReportsSubView(subViewName: selectedOption)
                    }
                }
            }
            .navigationTitle("My Findings")
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MyFindingsView()
}
