//
//  ImageEncoderService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/3/26.
//

import Foundation
import WebP
import UIKit
import SwiftUI

struct ImageEncoderService {
    
    func processAndUpload(using reportContainer: String, tracker: PhotoUploadTracker) async {
        guard let rawImage = tracker.localResource.data else {
            setPhase(tracker, to: .failure)
            return
        }
        
        do {
            /// Optimizing Phase
            setPhase(tracker, to: .optimizing)
            
            let data = rawImage.fixedOrientation()
            
            let webPData = try await Task.detached(priority: .userInitiated) {
                return try autoreleasepool {
                    try WebPEncoder().encode(
                        data,
                        config: .preset(.picture, quality: 80),
                        width: Int(data.size.width / 1.5),
                        height: Int(data.size.height / 1.5)
                    )
                }
            }.value
            
            /// Uploading Phase
            setPhase(tracker, to: .uploading)
            
            /// Update ReportsService to upload a single image and accept the delegate
            let response = try await ReportsService().uploadSinglePicture(
                reportContainer: reportContainer,
                imageData: webPData,
                onProgress: { progress in
                    tracker.uploadProgress = progress
                }
            )
            
            /// Success Phase
            tracker.key = response.data.key
            tracker.name = response.data.name
            tracker.uploadProgress = 1.0
            setPhase(tracker, to: .success)
            
        } catch {
            print("Failed to process/upload image: \(error)")
            setPhase(tracker, to: .failure)
        }
    }
    
    @MainActor
    private func setPhase(_ tracker: PhotoUploadTracker, to phase: ImagePhase) {
        tracker.phase = phase
    }
}

// MARK: - fix orientation issues when photos are taken because iOS flips 
extension UIImage {
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
