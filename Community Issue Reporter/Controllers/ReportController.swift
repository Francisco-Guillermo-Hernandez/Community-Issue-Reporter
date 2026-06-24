//
//  ReportController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/6/26.
//

import Foundation
internal import Combine

@MainActor
class ReportController: ObservableObject {
    
    @Published var reportId: String = ""
    @Published var isLoading: Bool = false
    @Published var presentAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var shareableLink: String = ""
    
    func startRePorting(_ model: ReportDataModel) async {
        do {
            let result = try await ReportRepository.shared.start()
            model.updateReportSession(result.data)
        } catch {
            
        }
    }
    
    func submitAttachments(attachments: [Attachment]) async {
        do {
            
        } catch CommonIntercommunicationErrors.networkError(let error) {
            showAlert(message: error)
        } catch CommonIntercommunicationErrors.serverError {
            showAlert(message: "Something went wrong, please try again later")
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
    
    func createReport(_ model: ReportDataModel) async {
        do {
            isLoading = true
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
        
        isLoading = false
    }
    
    func submitReport(_ model: ReportDataModel) {
        Task {
            await createReport(model)
            await createShareableLink(model)
//            await submit
        }
     }
     
    
    private func showAlert(message: String) {
        presentAlert = true
        alertMessage = message
    }

}
