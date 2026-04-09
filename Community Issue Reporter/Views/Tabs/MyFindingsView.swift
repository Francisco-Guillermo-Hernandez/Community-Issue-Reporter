//
//  MyFindingsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI

struct MyFindingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedOption: String = "My Reports"
    let options: [String] = ["My Reports", "My Petitions", "Signed Petitions"]
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedOption {
                    case "My Reports":
                        MyReportsSubView(subViewName: selectedOption)
                    case "My Petitions":
                        MyPetitionsSubView(subViewName: selectedOption)
                    case "Signed Petitions":
                        SignedPetitionsSubView(subViewName: selectedOption)
                        
                    default:
                        EmptyView()
                }
            }
            .navigationTitle("My Findings")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    Picker("Options", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .optionalGlassWithShape(colorScheme, shape: .capsule)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .pickerStyle(.segmented)
                    .controlSize(ControlSize.large)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            // TODO: reload content on selected sub-wiew
                        } label: {
                            Image(systemName: "arrow.2.circlepath.circle")
                        }
                    }
                }
                .toolbarBackground(.hidden)
        
            }
        }
    }
}
#Preview {
    MyFindingsView()
}
