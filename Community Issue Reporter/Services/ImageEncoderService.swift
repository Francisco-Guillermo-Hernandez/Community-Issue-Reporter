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
    
    func prepareAndSend(reportId: String, images: [MediaResources]) async {
            do {
                let webPData = try await withThrowingTaskGroup(of: Data.self) { group in
                    for image in images {
                        print(image.metadata)
                        print(image.type)
                        if let data = image.data {
                            group.addTask(priority: .high) {
                                
                                
                                    
                                    try autoreleasepool {
                                        return try WebPEncoder().encode(
                                            data,
                                            config: .preset(.picture, quality: 80),
                                            width: Int(data.size.width / 1.5) ,
                                            height: Int(data.size.height / 1.5),
                                        
                                            
                                        )
                                    }
                                
                                
                               
                            }
                        }
                       
                    }
                    
                    var results: [Data] = []
                    for try await data in group {
                        results.append(data)
                    }
                    return results
                }
                
                
                // Upload the results
                _ = try await ReportsService().attachPicture(reportId: reportId, imagesData: webPData)
            } catch {
                print(error)
            }
        }
    
    // ReportsService instance (Assuming it exists based on your snippet)
    private let reportsService = ReportsService()
//
    func prepareAndSend(
        reportId: String,
        states: Binding<[ImageUploadState]>,
        onComplete: @escaping () -> Void
    ) async {
//        await withThrowingTaskGroup(of: (Int, Bool).self) { group in
//            for index in states.indices {
//                group.addTask(priority: .userInitiated) {
//                    do {
//                        // 1. Encoding Step
//                        await MainActor.run { states[index].wrappedValue.status = .encoding }
//                        
//                        let data = try autoreleasepool {
//                            try WebPEncoder().encode(states[index].wrappedValue.image, config: .preset(.picture, quality: 80))
//                        }
//                        
//                        // 2. Uploading Step
//                        await MainActor.run { states[index].wrappedValue.status = .uploading }
//                        try await reportsService.attachPicture(reportId: reportId, imagesData: [data])
//                        
//                        return (index, true)
//                    } catch {
//                        return (index, false)
//                    }
//                }
//            }
//            
//            for try await (index, success) in group {
//                await MainActor.run {
//                    states[index].wrappedValue.status = success ? .success : .failure
//                }
//            }
//        }
//        
//        // Final closure trigger
//        await MainActor.run {
//            if states.wrappedValue.allSatisfy({ $0.status == .success }) {
//                onComplete()
//            }
//        }
    }
}
