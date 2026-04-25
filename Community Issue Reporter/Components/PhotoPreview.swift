//
//  PhotoPreview.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

@ViewBuilder
func photoPreview(_ photo: PhotoSample) -> some View  {
    Image(photo.photo)
        .resizable()
        .aspectRatio(1, contentMode: .fill)
//        .frame(width: 160, height: 160)
        .cornerRadius(16)
        .overlay {
            ZStack(alignment: .bottomLeading) {
                
                RoundedRectangle(cornerRadius: 16)
                
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .black.opacity(0.8), location: 0),
                                .init(color: .black.opacity(0.4), location: 0.5),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                //                                                        .stroke(issue.status.color, lineWidth: 2)
                    .cornerRadius(16)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(photo.user)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(photo.published.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
        }
}
