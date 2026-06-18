//
//  PetitionDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import SwiftUI
internal import Combine

class PetitionDataModel: ObservableObject {
    

    @Published var petition: Petition = .init(
        id: "",
        title: "",
        description: "",
        targetSignatures: 10,
        currentSignatures: 0,
        categoryId: 1,
        statusId: 1,
        reportedBy: UUID(),
        disabled: false,
        createdAt: Date(),
        updatedAt: Date(),
        reportsIds: [],
        attachments: [],
        postMetadata: .init(audience: "", visibility: .published, countryCode: .SV, language: "es", shareLink: ""),
        postPublisher: .init(username: "", avatar: "", profileId: ""),
        reportsMetadata: []
    )
     
    
    func prepareForModification(_ petition: Petition) {
        self.petition = petition
    }
    
    var isValid: Bool {
        petition.title.isEmpty || petition.description.isEmpty || petition.targetSignatures == 0
    }
}
