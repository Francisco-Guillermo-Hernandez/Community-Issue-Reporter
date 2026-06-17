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
    @Published var isGuest: Bool = false
    @Published var avatarURL: URL?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Persistence keys
    private let selectedOptionKey = "selected_avatar_option"
    private let selectedColorKey = "selected_avatar_color"

    @Published var selectedAvatarOptionView: AvatarCreatedFrom {
        didSet {
            UserDefaults.standard.set(selectedAvatarOptionView.rawValue, forKey: selectedOptionKey)
        }
    }

    @Published var selectedAvatarColor: Color {
        didSet {
            if let hex = selectedAvatarColor.toHex() {
                UserDefaults.standard.set(hex, forKey: selectedColorKey)
            }
        }
    }
    
    // Default background colors for selection
    let backgroundColors: [Color] = [
        .indigo, .purple, .init(red: 0.4, green: 0.2, blue: 0.6), .blue, .init(red: 0.5, green: 0.1, blue: 0.3), .pink,
        .emerald, .green, .init(red: 0.6, green: 0.8, blue: 0.1), .cyan, .init(red: 0.1, green: 0.7, blue: 0.9), .init(red: 0.1, green: 0.9, blue: 0.9),
        .yellow, .orange, .init(red: 1.0, green: 0.5, blue: 0.2), .red, .init(red: 0.9, green: 0.1, blue: 0.4), .init(red: 0.8, green: 0.1, blue: 0.7)
    ]
    
    init() {
        let savedOption = UserDefaults.standard.string(forKey: selectedOptionKey) ?? AvatarCreatedFrom.GoogleAuth.rawValue
        self.selectedAvatarOptionView = AvatarCreatedFrom(rawValue: savedOption) ?? .GoogleAuth
        
        let savedColorHex = UserDefaults.standard.string(forKey: selectedColorKey) ?? "ec9458" // Default orange
        self.selectedAvatarColor = Color(hex: savedColorHex)
        
        if selectedAvatarOptionView == .GoogleAuth, let url = UserRepository.shared.getProfilePictureURL() {
            UserDefaults.standard.set(url, forKey: "avatar_url")
        }
        
        self.avatarURL = UserDefaults.standard.string(forKey: "avatar_url").flatMap(URL.init(string:))
        
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .map { _ in UserDefaults.standard.string(forKey: "avatar_url").flatMap(URL.init(string:)) }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: &$avatarURL)
    }
    
    func applyGoogleAvatar(completion: @escaping () -> Void) {
        guard let url = UserRepository.shared.getProfilePictureURL() else { return }
        isUploading = true
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    await MainActor.run { isUploading = false }
                    return
                }
                
                await MainActor.run {
                    uploadProfilePicture(image, from: .GoogleAuth)
                    completion()
                }
            } catch {
                await MainActor.run { isUploading = false }
                print("Failed to fetch Google avatar: \(error)")
            }
        }
    }
    
    
    @MainActor
    func uploadProfilePicture(_ image: UIImage, from: AvatarCreatedFrom) {
        isUploading = true
        
        Task {
            do {
                
                let urlString = try await UserRepository.shared.changeAvatar(image, from)
                
                self.avatarURL = URL(string: urlString)
                self.profileImage = image
                print("Upload success: \(urlString)")
                
            } catch {
                print("Upload failed: \(error.localizedDescription)")
            }

            isUploading = false
        }
    }
    
    @MainActor
    func getMonogram() -> String {
        print(userName)
        return String(userName.prefix(1)).uppercased()
    }
    
    @MainActor
    func getInitials() -> String {
        let components = userName.components(separatedBy: " ")
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let second = components[1].prefix(1)
            return "\(first)\(second)".uppercased()
        }
        return String(userName.prefix(2)).uppercased()
    }
    
    @MainActor
    func setUserName(_ name: String) {
        userName = name
    }
}

extension Color {
    static let emerald = Color(red: 0.0, green: 0.78, blue: 0.58)
}
