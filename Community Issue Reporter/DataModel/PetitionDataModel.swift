//
//  PetitionDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import SwiftUI

@Observable
final class PetitionDataModel {
    
    static let shared = PetitionDataModel()

    var petition: Petition
    private init () {
        self.petition = .init(id: "", title: "", description: "", targetSignatures: 0, currentSignatures: 0, categoryId: 1, statusId: 1, reportedBy: UUID(), disabled: false, createdAt: Date(), updatedAt: Date())
    }
    
    func update(_ petition: Petition) {
        self.petition = petition
    }
    
    var isValid: Bool {
        petition.title.isEmpty || petition.description.isEmpty || petition.targetSignatures == 0
    }
}
