//
//  CitizenProfileController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/8/26.
//

import SwiftUI
import Foundation
import Observation

@MainActor
@Observable
final class CitizenProfileController {
    
    var citizen: User
    var containerSize: CGSize
    var reportsSubmitted: Int
    var showBlockUserSheet: Bool
    var petitionsPublished: Int
    var petitions: [PetitionPost]
    var scrollProgress: CGFloat
    var scrollPosition: ScrollPosition
    var isLoading: Bool
    var reports: [Report]
    var fetchingReports: Bool
    
    init () {
        self.isLoading = false 
        self.petitions = []
        self.fetchingReports = false
        self.reports = []
        self.scrollProgress = 0
        self.scrollPosition = .init()
        self.containerSize = .zero
        self.showBlockUserSheet = false
        self.petitionsPublished = 0
        self.reportsSubmitted = 0
        self.citizen = .init(
            names: "Guest Citizen",
            userName: "guest",
            profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png",
            profileId: "guest",
            userSince: Date(),
            hideProfile: false
        )
    }
    
    func fetchCitizenPublicProfile(_ profileId: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.citizen = try await UserRepository.shared.citizenProfile(id: profileId)
        } catch {
            print("Error fetching citizen public profile: \(error)")
        }
    }
    
    func fetchReports(_ profileId: String) async {
        do {
            self.fetchingReports = true
            let documents = try await ReportRepository.shared.listByProfile(profileId)
            self.reports = documents.map { $0.toModel() }
            self.reportsSubmitted = reports.count
        } catch {
            print("Error fetching reports by profile: \(error)")
        }
        
        self.fetchingReports = false
    }
}
