//
//  EvidencesView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

struct EvidencesView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a", published: Date(), user: "Jane Doe"),
        PhotoSample(id: "2", photo: "b", published: Date(), user: "John Smith"),
        PhotoSample(id: "3", photo: "c", published: Date(), user: "Michael Brown"),
        PhotoSample(id: "4", photo: "d", published: Date(), user: "Emily Davis"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: gridColumns, spacing: 4) {
                    ForEach(photos, id: \.id) { photo in
                        photoPreview(photo)
                    }
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("gallery", systemImage: "photo.on.rectangle") {
                        
                    }
                    .accessibilityLabel("Add more Evidence from your Gallery")
                    Button("Add more Evidence", systemImage: "camera") {
                        
                    }
                    .accessibilityLabel("Add more Evidences by taking a photo")
                }
                
                
            }
            .navigationTitle("Evidences")
            .navigationSubtitle("You can take a look of what is happening")
        }
    }
    
    fileprivate let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
}

#Preview {
    EvidencesView()
}
