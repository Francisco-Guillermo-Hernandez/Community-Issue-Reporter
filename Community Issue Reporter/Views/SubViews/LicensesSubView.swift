//
//  LicencesSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct License: Identifiable {
    let id: String
    let library: String
    let text: String
}

struct LicensesSubView: View {
    @Environment(\.dismiss) private var dismiss
    var subViewName: String
    
    @State private var licenses: Array<License> = []
    @State private var expandedLicenseIDs: Set<String> = []
    @State private var expandAll = true
    
    private func loadTextResource(
        fileName: String,
        fileExtension: String,
        subdirectory: String? = nil
    ) -> String {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: fileExtension,
            subdirectory: subdirectory
        ) else {
            return "License text not available."
        }
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
                        License(id: "1", library: "Google SignIn", text: loadTextResource(
                            fileName: "LICENSE",
                            fileExtension: "",
                            subdirectory: "Licenses/GoogleSignIn"
                        )),
                        License(id: "2", library: "IP2LOCATION LITE DB3", text: loadTextResource(
                            fileName: "LICENSE_LITE",
                            fileExtension: "TXT",
                            subdirectory: "Licenses/IP2LOCATION-LITE-DB3.CSV"
                        )),
                        License(id: "3", library: "Libwebp", text: loadTextResource(
                            fileName: "COPYING",
                            fileExtension: "",
                            subdirectory: "Licenses/libwebp"
                        )),
                        License(id: "4", library: "Promises", text: loadTextResource(
                            fileName: "LICENSE",
                            fileExtension: "",
                            subdirectory: "Licenses/Promises"
                        )),
                        License(id: "5", library: "WebP", text: loadTextResource(
                            fileName: "LICENSE",
                            fileExtension: "",
                            subdirectory: "Licenses/WebP"
                        )),
                        License(id: "6", library: "AppAuth", text: loadTextResource(
                            fileName: "LICENSE",
                            fileExtension: "",
                            subdirectory: "Licenses/AppAuth"
                        )),
                        License(id: "7", library: "Photos from Unsplash", text: loadTextResource(
                            fileName: "CREDITS",
                            fileExtension: "",
                            subdirectory: "Licenses/Unsplash"
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
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.down.backward")
                    }
                }
                
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
//                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    configuration.label
                    Spacer()
//                    Text(configuration.isExpanded ? "hide" : "show")
//                        .foregroundColor(.accentColor)
//                       .font(.caption.lowercaseSmallCaps())
//                        .animation(nil, value: configuration.isExpanded)
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
