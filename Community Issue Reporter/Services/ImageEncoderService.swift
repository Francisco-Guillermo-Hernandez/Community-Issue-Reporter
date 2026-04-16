//
//  ImageEncoderService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/3/26.
//

import Foundation
import WebP
import UIKit

struct ImageEncoderService {
    
    func prepareAndSend(reportId: String, images: [UIImage]) async {
        do {
            let webPData = try await withThrowingTaskGroup(of: Data.self) { group in
                for image in images {
                    group.addTask(priority: .high) {
                        
                        try autoreleasepool {
                            return try WebPEncoder().encode(image, config: .preset(.picture, quality: 80))
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
}
