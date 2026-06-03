//
//  ProfileDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/5/26.
//

import SwiftUI
import PhotosUI
import CoreTransferable
internal import Combine


enum AvatarSource {
    case camera
    case library
    case emoji(String, Color)
    case collectible(String, Color)
    case monogram(String, Color)
    case initials(String, Color)
}

final class ProfileDataModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var userName: String = "Demo User"
    @Published var isUploading: Bool = false
    @Published var showPicker: Bool = false
    
    // Default background colors for selection
    let backgroundColors: [Color] = [
        .indigo, .purple, .init(red: 0.4, green: 0.2, blue: 0.6), .blue, .init(red: 0.5, green: 0.1, blue: 0.3), .pink,
        .emerald, .green, .init(red: 0.6, green: 0.8, blue: 0.1), .cyan, .init(red: 0.1, green: 0.7, blue: 0.9), .init(red: 0.1, green: 0.9, blue: 0.9),
        .yellow, .orange, .init(red: 1.0, green: 0.5, blue: 0.2), .red, .init(red: 0.9, green: 0.1, blue: 0.4), .init(red: 0.8, green: 0.1, blue: 0.7)
    ]
    
    func uploadProfilePicture(_ image: UIImage) {
        isUploading = true
        
        Task {
           await UserRepository.shared.uploadImage(image, userName: userName) { [weak self] (result: Result<String, Error>) in
                DispatchQueue.main.async {
                    self?.isUploading = false
                    switch result {
                    case .success(let url):
                        print("Upload success: \(url)")
                        self?.profileImage = image
                    case .failure(let error):
                        print("Upload failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getMonogram() -> String {
        return String(userName.prefix(1)).uppercased()
    }
    
    func getInitials() -> String {
        let components = userName.components(separatedBy: " ")
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let second = components[1].prefix(1)
            return "\(first)\(second)".uppercased()
        }
        return String(userName.prefix(2)).uppercased()
    }
}

extension Color {
    static let emerald = Color(red: 0.0, green: 0.78, blue: 0.58)
}
