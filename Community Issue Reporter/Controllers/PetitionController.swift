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
    var currentStep: PetitionStep
    var doneTrigger: Bool
    var shareUrl: String
    
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
        currentStep = .details
        doneTrigger = false
        shareUrl = ""
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
            self.reports = reports.map { $0.toModel() }
            
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    func goNext() {
        if let next = PetitionStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        }
    }
    
    func goBack() {
        if let prev = PetitionStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }
    
    func submit() {
//        Task {
//          
//            do {
//                _ = try await PetitionRepository.share.create(petition)
//                
//            } catch {
//               
//            }
//                
//            isSubmitting.toggle()
//        }
        if currentStep == .signatures {
            self.goNext()
        } else {
            print("otherSteps")
            self.goNext()
        }
    }
    
    var buttonMessage: String {
        currentStep == .signatures ? String(localized: "Submit") : String(localized: "Next")
    }
}



//if currentStep == .details {
//   
//    submitReport(model, attachments: uploadTrackers) {
//        self.goNext()
//    }
//    
//} else {
//    self.goNext()
//}
