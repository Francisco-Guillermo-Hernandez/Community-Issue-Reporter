//
//  PetitionController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/6/26.
//

import SwiftUI
internal import Combine

@MainActor
class PetitionController: ObservableObject {
    
    @Published var petitions: [Petition] = []
    @Published var isLoading: Bool = false
}
