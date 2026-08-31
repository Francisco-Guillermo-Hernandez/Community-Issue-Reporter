//
//  ReportController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/6/26.
//

import Foundation
internal import Combine
import Observation

@MainActor
@Observable
class ReportController {
    
    var reportId: String = ""
    var isLoading: Bool = false
    var presentAlert: Bool = false
    var alertMessage: String = ""
    var shareableLink: String = ""
    var doneTrigger: Bool = false
    var currentStep: ReportStep = .location
    var groupingResult: CustomizedResponse<[ReportAttachmentGrouping]>? = nil
    
    func startRePorting(_ model: ReportDataModel) async {
        do {
            if model.report.reportState == .modifying {
                
                print("Modifying report")
                
                guard let reportId = model.report.id else {
                    throw ReportError.noIdentifier
                }
                guard let cityId = model.report.cityId else {
                    throw ReportError.noIdentifier
                }
                
                let reportContainer = model.report.reportContainer ?? ""
                
                /// Get metadata
                let (countryCode, reportSession) = model.getMetadataFromReportId(reportId, reportContainer)
                
                /// Update report session
                model.updateReportSession(reportSession)
                
                /// Set locator using metadata information
                model.setLocator(countryCode: countryCode, cityId: cityId)
                
                print("setLocator")
                dump(model.locator)
                
                print("reportsession")
                dump(model.reportSession)
            } else {
                let result = try await ReportRepository.shared.start()
                model.updateReportSession(result.data)
            }
            
        } catch {
            print("startReporting: ")
            print(error)
        }
    }
    
    func createShareableLink(_ model: ReportDataModel) async throws {
//        let url = try await ShareRepository.shared.createShareableLink(using: model)
        let url = ""
        shareableLink = url
    }
    
    func createReport(using model: ReportDataModel) async throws {
        let result = try await ReportRepository.shared.create(using: model)
        model.report.id = result
        self.reportId = result
    }
    
    func submitGroupedAttachments(with attachments: [PhotoUploadTracker], using model: ReportDataModel) async throws -> CustomizedResponse<[ReportAttachmentGrouping]>? {
        
        let newAttachments = attachments.filter { !$0.isExisting }
        guard !newAttachments.isEmpty else { return nil }
        
        var reportId = model.buildReportId()
        
        if model.report.reportState == .modifying, let id = model.report.id {
            reportId = id
        }
        
        print("reportId: \(reportId)")
        print("AttachmentContainer: \(model.reportSession.reportContainer)")
        
        let payload = newAttachments.map { tracker in
            GroupedAttachmentPayload(
                attachmentContainer: model.reportSession.reportContainer,
                key: tracker.key,
                previewFileName: "preview_\(tracker.name)",
                fileName: tracker.name,
                reportId: reportId,
                notes: ""
            )
        }
        
        return try await ReportRepository.shared.submitGroupedAttachments(attachments: payload)
        
    }
    
    func modify(using model: ReportDataModel, with attachments: [PhotoUploadTracker]) async {
        do {
            guard let id = model.report.id else { return }
            self.reportId = id
            
            guard let url = model.report.shareUrl else { return }
            
            shareableLink = url
            
            let result = try await ReportRepository.shared.update(model.report)
            if result == .updated {
                _ = try await submitGroupedAttachments(with: attachments, using: model)
            }
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
    
    func submitReport(_ model: ReportDataModel, attachments: [PhotoUploadTracker], onComplete: @escaping () -> Void) {
        Task {
            isLoading = true
            
            model.addAttachments(attachments)
            
            if model.report.reportState == .modifying {
               
                await modify(using: model, with: attachments)
               
            } else {
                
                do {
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        
                        group.addTask {
                            let result = try await self.submitGroupedAttachments(with: attachments, using: model)
                            if let data = result {
                                await model.setAttachmentId(data.data)
                            }
                            try await self.createReport(using: model)
                        }
                        
                        group.addTask {
                            try await self.createShareableLink(model)
                        }
                        
                        for try await _ in group {}
                    }
                } catch CommonIntercommunicationErrors.invalidPetition(let code) {
                    showAlert(message: code)
                } catch CommonIntercommunicationErrors.networkError(let error) {
                    showAlert(message: error)
                } catch CommonIntercommunicationErrors.serverError {
                    showAlert(message: "Something went wrong, please try again later")
                } catch {
                    showAlert(message: error.localizedDescription)
                }
            }
            
            model.removeAttachments()
            isLoading = false
            
            onComplete()
        }
     }
     
    
    private func showAlert(message: String) {
        presentAlert = true
        alertMessage = message
    }

        
    func goNext() {
        if let next = ReportStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        }
    }
    
    func goBack() {
        if let prev = ReportStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }
    
    var buttonMessage: String {
        currentStep == .details ? String(localized: "Submit") : String(localized: "Next")
    }
    
    func submit(_ model: ReportDataModel, _ uploadTrackers: [PhotoUploadTracker]) -> Void {
         
        if currentStep == .details {
           
            submitReport(model, attachments: uploadTrackers) {
                self.goNext()
            }
            
        } else {
            self.goNext()
        }
    }
}



