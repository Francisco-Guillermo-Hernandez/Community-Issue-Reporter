//
//  PetitionDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import SwiftUI
internal import Combine

//@Observable
 class PetitionDataModel: ObservableObject {
    
    
//    static let shared = PetitionDataModel()

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
    )
     
    
    func prepareForModification(_ petition: Petition) {
        self.petition = petition
    }
    
    var isValid: Bool {
        petition.title.isEmpty || petition.description.isEmpty || petition.targetSignatures == 0
    }
}
