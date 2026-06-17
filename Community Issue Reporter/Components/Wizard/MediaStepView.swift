//
//  MediaStepView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct MediaStepView: View {
    @Binding var media: [UIImage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Add Photo Button
                    Button(action: {
                        if let img = UIImage(systemName: "photo.fill") {
                            media.append(img)
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text("Add Photo")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .frame(width: 88, height: 88)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Attached photos
                    ForEach(0..<media.count, id: \.self) { idx in
                        Image(uiImage: media[idx])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88, height: 88)
                            .cornerRadius(12)
                            .clipped()
                            .overlay(
                                Button(action: { media.remove(at: idx) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(4),
                                alignment: .topTrailing
                            )
                    }
                    
                    if media.isEmpty {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.3), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [4, 4]))
                            .frame(width: 88, height: 88)
                            .overlay(
                                Image(systemName: "photo.on.rectangle")
                                    .foregroundColor(.secondary)
                            )
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}


#Preview {
    MediaStepView(media: .constant([]))
}
