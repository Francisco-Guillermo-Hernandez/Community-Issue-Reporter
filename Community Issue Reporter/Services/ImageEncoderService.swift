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

    
    func prepareToSent(reportId: String, images: [UIImage], completion: @escaping (String) -> ()) {
        Task.detached(priority: .background) {
            do {
                var webPData: [Data] = []
                
                for image in images {
                    let encodedData = try autoreleasepool {
                        return try WebPEncoder().encode(image, config: .preset(.picture, quality: 80))
                    }
                    print("Processing image")
                    
                    webPData.append(encodedData)
                }
                
                _ = try await ReportsService().attachPicture(reportId: reportId, imagesData: webPData)
                
                await MainActor.run {
                    completion("completion")
                }
            } catch {
                print(error)
            }
        }
    }
    
}
