//
//  ImageCache.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 31/5/26.
//

import Foundation
import SwiftUI
import UIKit

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
    
    init() {
        // Configure cache limits
        ImageCache.shared.countLimit = 256 // Maximum 256 images
        ImageCache.shared.totalCostLimit = 256 * 1024 * 1024 // 256MB limit
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL
    let scale: CGFloat
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var cachedImage: UIImage?

    init(
        url: URL,
        scale: CGFloat = 1.0,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder
        
        print("url: \(url)")
    }

    var body: some View {
        Group {
            if let cachedImage {
                content(Image(uiImage: cachedImage))
            } else {
                AsyncImage(url: url, scale: scale) { phase -> AnyView in
                    switch phase {
                    case .success(let image):
                        // Save to cache when AsyncImage successfully loads
                        saveToCache(from: url)
                        return AnyView(content(image))
                    case .failure(_):
                        return AnyView(placeholder())
                    case .empty:
                        return AnyView(placeholder())
                    @unknown default:
                        return AnyView(placeholder())
                    }
                }
            }
        }
        .task {
            loadFromCache()
        }
    }

    private func loadFromCache() {
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            cachedImage = cached
            
            print("load from cache")
        }
    }
    
    private func saveToCache(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                        if cachedImage == nil {
                            cachedImage = uiImage
                            print("Image saved into the cache")
                        }
                    }
                }
            } catch {
                print("Image caching failed: \(error)")
            }
        }
    }
}
