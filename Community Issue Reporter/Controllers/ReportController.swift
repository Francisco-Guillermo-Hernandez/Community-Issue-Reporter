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
                
                let reportContainer = model.report.attachments.first?.reportContainer ?? ""
                
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
    
    func createShareableLink(_ model: ReportDataModel) async {
        do {
           
            let url = try await ShareRepository.shared.createShareableLink(using: model)
            shareableLink = url
        }  catch CommonIntercommunicationErrors.invalidPetition(let code) {
            showAlert(message: code)
        } catch CommonIntercommunicationErrors.networkError(let error) {
            showAlert(message: error)
        } catch CommonIntercommunicationErrors.serverError {
          showAlert(message: "Something went wrong, please try again later")
        } catch {
            print(error)
        }
    }
    
    func createReport(using model: ReportDataModel) async {
        do {
            let result = try await ReportRepository.shared.create(using: model)
            model.report.id = result
            reportId = result
            
        } catch CommonIntercommunicationErrors.invalidPetition(let code) {
            showAlert(message: code)
        } catch CommonIntercommunicationErrors.networkError(let error) {
            showAlert(message: error)
        } catch CommonIntercommunicationErrors.serverError {
          showAlert(message: "Something went wrong, please try again later")
        } catch {
            print(error)
        }
    }
    
    func submitGroupedAttachments(with attachments: [PhotoUploadTracker], using model: ReportDataModel) async {
        do {
      
            var reportId = model.buildReportId()
            
            if model.report.reportState == .modifying, let id = model.report.id {
                reportId = id
            }
            
            print("reportId: \(reportId)")
            print("AttachmentContainer: \(model.reportSession.reportContainer)")
            
            let payload = attachments.map { tracker in
                GroupedAttachmentPayload(
                    attachmentContainer: model.reportSession.reportContainer,
                    key: tracker.key,
                    previewFileName: "preview_\(tracker.name)",
                    fileName: tracker.name,
                    reportId: reportId,
                    notes: ""
                )
            }
            
            let result = try await ReportRepository.shared.submitGroupedAttachments(attachments: payload)
            
            if result == .created {
                print("created")
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
    
    func modify(using model: ReportDataModel, with attachments: [PhotoUploadTracker]) async {
        do {
            guard let id = model.report.id else { return }
            reportId = id
            
            print("reportId")
            print(reportId)
            
            print("reportContainer")
            print(model.report.attachments[0].reportContainer)
            model.reportSession.reportContainer = model.report.attachments[0].reportContainer
            let result = try await ReportRepository.shared.update(model.report)
            if result == .updated {
                await submitGroupedAttachments(with: attachments, using: model)
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
                async let a = createShareableLink(model)
                async let b = createReport(using: model)
                async let c = submitGroupedAttachments(with: attachments, using: model)
                
                _ = await (a, b, c)
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
