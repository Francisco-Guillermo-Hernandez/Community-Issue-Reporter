//
//  PhotoPreview.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

@ViewBuilder
func photoPreview(_ attachment: PreviewAttachment) -> some View  {
    
    if let url = attachment.url {
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160, alignment: .top)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        
                        RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous)
                        
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
                            .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                            .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.4, style: .continuous))
                        
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(attachment.uploaderUserName)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(attachment.createdAt.formatted(date: .numeric, time: .omitted))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                    }
                }
        } placeholder: {
            ProgressView()
                .frame(width: 160, height: 160)
        }
//        .frame(width: 48, height: 48)
//        .clipShape(Circle())
        .id(url)
    }
       
}
