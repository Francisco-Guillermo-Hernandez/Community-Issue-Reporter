//
//  PhotoUploadTracker.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/6/26.
//

import Foundation
import SwiftUI
import Observation // Use @Observable if targeting iOS 17+, otherwise use ObservableObject

@Observable
class PhotoUploadTracker: Identifiable {
    let id = UUID()
    let localResource: MediaResources
    
    var phase: ImagePhase = .optimizing
    var uploadProgress: Float = 0.0
    var remoteUUID: String? = nil // Store the backend ID here for deletion
    
    init(localResource: MediaResources) {
        self.localResource = localResource
    }
}


enum ImagePhase: String, CaseIterable {
    case optimizing
    case uploading
    case success
    case failure
    
    var description: String {
        switch self {
        case .optimizing:
            return String(localized: "Optimizing")
        case .uploading:
            return String(localized: "Uploading")
        case .success:
            return String(localized: "Uploaded")
            
        case .failure:
            return String(localized: "Failed")
        }
    }
}


class UploadProgressDelegate: NSObject, URLSessionTaskDelegate {
    var onProgress: ((Float) -> Void)?
    
    init(onProgress: @escaping (Float) -> Void) {
        self.onProgress = onProgress
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        // Ensure UI updates happen on the Main Actor
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
