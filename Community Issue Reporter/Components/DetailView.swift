//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    var issue: IssueMarker
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(issue.title)
                    .font(.subheadline)
                    .bold()
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Text(issue.title)
                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem() {
                    ShareLink(item: "") {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            
        }
        .presentationDetents([.medium, .fraction(0.2)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
//    DetailView()
}
