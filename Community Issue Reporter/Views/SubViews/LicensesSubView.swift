//
//  LicensesSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct License: Identifiable {
    let id = UUID().uuidString
    let library: String
    let text: String
}

struct LicensesSubView: View {
    @Environment(\.dismiss) private var dismiss
    var subViewName: String
    
    @State private var licenses: Array<License> = []
    @State private var expandedLicenseIDs: Set<String> = []
    @State private var expandAll = true
    
    private func loadTextResource(fileName: String) -> String {
        // Splits "GoogleSignIn.LICENSE" into name: "GoogleSignIn", extension: "LICENSE"
        let components = fileName.split(separator: ".")
        guard components.count == 2,
              let url = Bundle.main.url(forResource: String(components[0]), withExtension: String(components[1])) else {
            return "License text not available."
        }
        
        print(url)
        
        return (try? String(contentsOf: url, encoding: .utf8)) ?? "License text not available."
    }
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical, showsIndicators: true) {
                
                LazyVStack {
                    
                    ForEach(licenses) { license in
                        
                        DisclosureGroup(
                            license.library,
                            isExpanded: Binding(
                                get: { expandedLicenseIDs.contains(license.id) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedLicenseIDs.insert(license.id)
                                    } else {
                                        expandedLicenseIDs.remove(license.id)
                                    }
                                }
                            )
                        ) {
                            Text(license.text)
                                .font(.caption)
                            Divider()
                                .padding(.bottom, 4)
                        }
                        .disclosureGroupStyle(DisclosureStyle())
                    }
                    
                }
                .padding()
                .task {
                    
                    let loadedLicenses = [
                        License(library: "Google SignIn", text: loadTextResource(
                            fileName: "GoogleSignIn.LICENSE"
                        )),
                        License(library: "Libwebp", text: loadTextResource(
                            fileName: "libwebp.COPYING"
                        )),
                        License(library: "Promises", text: loadTextResource(
                            fileName: "Promises.LICENSE"
                        )),
                        License(library: "WebP", text: loadTextResource(
                            fileName: "WebP.LICENSE"
                        )),
                        License(library: "AppAuth", text: loadTextResource(
                            fileName: "LICENSE"
                        )),
                        License(library: "Photos from Unsplash", text: loadTextResource(
                            fileName: "Unsplash.CREDITS"
                        )),
                    ]
                    
                    self.licenses = loadedLicenses
                    self.expandedLicenseIDs = Set(loadedLicenses.map { $0.id })
                    self.expandAll = !loadedLicenses.isEmpty
                    
                }
                .onChange(of: expandAll) {_, isExpanded in
                    if isExpanded {
                        expandedLicenseIDs = Set(licenses.map { $0.id })
                    } else {
                        expandedLicenseIDs.removeAll()
                    }
                }
                .onChange(of: expandedLicenseIDs) { _, newValue in
                    let allExpanded = !licenses.isEmpty && newValue.count == licenses.count
                    if expandAll != allExpanded {
                        expandAll = allExpanded
                    }
                }
                
            }
            .navigationTitle(subViewName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        expandAll.toggle()
                    } label: {
                        if expandAll {
                            Image(systemName: "rectangle.compress.vertical")
                        } else {
                            Image(systemName: "rectangle.expand.vertical")
                        }
                    }
                }
            }
        }
        .interactiveDismissDisabled(true)
    }
}

struct DisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    configuration.label
                    Spacer()
                    Text(configuration.isExpanded ? "hide" : "show")
                        .foregroundColor(.accentColor)
                       .font(.caption.lowercaseSmallCaps())
                        .animation(nil, value: configuration.isExpanded)
                }
                .contentShape(Rectangle())
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}

#Preview {
    LicensesSubView(subViewName: "Licences")
}
