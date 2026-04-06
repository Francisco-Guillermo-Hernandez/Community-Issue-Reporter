//
//  LicencesSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct LicensesSubView: View {
    @Environment(\.dismiss) private var dismiss
    var subViewName: String

    @State private var licenseText: String = ""

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

        print("Loading: \(url.path)")
        return (try? String(contentsOf: url, encoding: .utf8)) ?? "License text not available."
    }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    
                    Text(self.licenseText)
                    
                    Divider()
                }
                .padding(20)
                .task {
                    self.licenseText =
                        loadTextResource(
                            fileName: "LICENSE_LITE",
                            fileExtension: "TXT",
                            subdirectory: ""
                        )
                    
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
            }
        }
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    LicensesSubView(subViewName: "Licences")
}
