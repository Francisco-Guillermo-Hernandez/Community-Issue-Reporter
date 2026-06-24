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
    
    func processAndUpload(reportId: String, tracker: PhotoUploadTracker) async {
        guard let data = tracker.localResource.data else {
            setPhase(tracker, to: .failure)
            return
        }
        
        do {
            /// Optimizing Phase
            setPhase(tracker, to: .optimizing)
            
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
            let remoteId = try await ReportsService().uploadSinglePicture(
                reportId: reportId,
                imageData: webPData,
                onProgress: { progress in
                    tracker.uploadProgress = progress
                }
            )
            
            /// Success Phase
            tracker.remoteUUID = remoteId
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
