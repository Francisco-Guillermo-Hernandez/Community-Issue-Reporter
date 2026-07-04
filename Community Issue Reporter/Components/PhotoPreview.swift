//
//  PhotoPreview.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

struct PhotoPreview: View {
    @State private var cornerRadius: CGFloat = .themeRadius * 1.4
    @State private var height: CGFloat = 160
    @State private var width: CGFloat = 160
    
    var attachment: PreviewAttachment
    
    init(_ attachment: PreviewAttachment) { self.attachment = attachment }
    
    var body: some View {
        if let url = attachment.url {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: height, height: width, alignment: .top)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay {
                        ZStack(alignment: .bottomLeading) {
                            
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: .black.opacity(0.6), location: 0),
                                            .init(color: .black.opacity(0.33), location: 0.5),
                                            .init(color: .clear, location: 1)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                                .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            
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
                            .padding(12)
                        }
                    }
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: height)
            }
            .id(url)
        }
    }
}

#Preview {
    let attachment =  PreviewAttachment(id: "24b93d66-07ff-4141-91ce-408b615123c3", type: .image, createdAtRaw: 0, updatedAtRaw: 0, uploaderUserName: "jhon.doe", validatedBy: .bot, state: .pending, fileName: "1783058838224-f02fb5e4-07d1-49d4-a9f5-742816b669c9.webp", reportContainer: "587d3ac3-0715-4958-8955-1d6d29a3d489")
    return PhotoPreview(attachment)
}
