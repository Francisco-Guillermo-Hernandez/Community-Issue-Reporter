//
//  PhotoUploadTracker.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/6/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
class PhotoUploadTracker: Identifiable {
    var id: String = UUID().uuidString
    var key: String = ""
    let localResource: MediaResources
    var url: URL? = nil
    
    var phase: ImagePhase = .optimizing
    var uploadProgress: Float = 0.0
    var name: String = ""
    var isExisting: Bool = false
    
    init(localResource: MediaResources, isExisting: Bool = false) {
        self.localResource = localResource
        self.isExisting = isExisting
    }
    
    init(key: String, name: String, url: URL?, isExisting: Bool = true) {
        self.key = key
        self.name = name
        self.url = url
        self.phase = .success
        self.uploadProgress = 1.0
        self.isExisting = isExisting
        self.localResource = MediaResources(
            type: .photo,
            data: nil,
            metadata: BasicMetadata(deviceOrientation: .portrait)
        )
    }
}


enum ImagePhase: String, CaseIterable, Equatable {
    case optimizing
    case uploading
    case success
    case failure
    case deleting
    
    var description: String {
        switch self {
        case .optimizing:
            return String(localized: "Optimizing")
        case .uploading:
            return String(localized: "Uploading")
        case .success:
            return String(localized: "Uploaded")
        case .deleting:
            return String(localized: "Deleting")
        case .failure:
            return String(localized: "Failed")
        }
    }
}


final class UploadProgressDelegate: NSObject, URLSessionTaskDelegate {
    var onProgress: ((Float) -> Void)?
    
    init(onProgress: @escaping (Float) -> Void) {
        self.onProgress = onProgress
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        /// Ensure UI updates happen on the Main Actor
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
