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
    
    init () {
        self.petitions = []
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
            profileId: "guest"
        )
    }
    
    func fetchCitizenPublicProfile(_ profileId: String) async {
        self.citizen = User(names: "Jane Doe", userName: "jane.doe", profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png", profileId: "uiEw3sSu1zcQ1U9")
    }
}
