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
    
    func startRePorting(_ model: ReportDataModel) async {
        do {
            let result = try await ReportRepository.shared.start()
            model.updateReportSession(result.data)
        } catch {
            
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
      
            let payload = attachments.map { tracker in
                GroupedAttachmentPayload(
                    attachmentContainer: model.reportSession.reportContainer,
                    key: tracker.key,
                    previewFileName: "preview_\(tracker.name)",
                    fileName: tracker.name,
                    reportId: model.buildReportId(),
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
    
    func submitReport(_ model: ReportDataModel, attachments: [PhotoUploadTracker], onComplete: @escaping () -> Void) {
        Task {
            isLoading = true
            model.addAttachments(attachments)
            
            async let a = createShareableLink(model)
            async let b = createReport(using: model)
            async let c = submitGroupedAttachments(with: attachments, using: model)
            
            _ = await (a, b, c)
            
            model.removeAttachments()
            isLoading = false
            
            onComplete()
        }
     }
     
    
    private func showAlert(message: String) {
        presentAlert = true
        alertMessage = message
    }

}
