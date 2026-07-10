//
//  PetitionController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 27/4/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class PetitionController {
    
    var reports: [Report]
    var petition: Petition
    var isTitleValid: Bool
    var isSubmitting: Bool
    var stepperAction: String
    var isDescriptionValid: Bool
    var minimumSignatures: Int
   
    init() {
        self.reports = []
        self.petition = .init(
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
            reportsIds: []
        )
        
        stepperAction = ""
        isSubmitting = false
        isTitleValid = false
        isDescriptionValid = false
        minimumSignatures = 10
    }
    
    func prepareForModification(_ petition: Petition) {
        self.petition = petition
    }
    
    var isValid: Bool {
        petition.title.isEmpty || petition.description.isEmpty || petition.targetSignatures == 0
    }
    
    func fetchReports() async {
        do {
            let result = try await ReportRepository.shared.listByUser(page: 1)
            guard let reports = result.documents else { return }
            self.reports = reports
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
