//
//  SwiftUIView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/4/26.
//

import SwiftUI

struct PetitionsTabView: View {
    var body: some View {
       
        // Example of removing the sidebar toggle button
//        NavigationSplitView {
//            List {
//                Text("Sidebar")
//            }
//            
//            .toolbar(removing: .sidebarToggle) // Hides the button
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button() {
//                        
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                    .buttonStyle(.glass)
//                }
//            }
//        } detail: {
//            Text("Detail View")
//        }
//        .navigationSplitViewStyle(.balanced)

        NavigationSplitView {
                    List {
                        Text("Sidebar Item")
                    }
                    .navigationTitle("Menu")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                print("Settings tapped")
                            }) {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                    }
                    // Optional: Remove default sidebar toggle
                    // .toolbar(removing: .sidebarToggle)
                } detail: {
                    NavigationStack {
                        Text("Detail View")
                            .toolbar {
                                // Toolbar at the top trailing edge
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        print("Settings tapped")
                                    }) {
                                        Label("Settings", systemImage: "gear")
                                    }
                                }
                            }
                            .navigationTitle("Content")
                    }
                }
    }
}


#Preview {
    PetitionsTabView()
}
