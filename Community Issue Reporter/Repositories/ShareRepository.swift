//
//  ShareRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/6/26.
//

import Foundation

final class ShareRepository {
    
    static let shared: ShareRepository = .init()
    
    var service: ShareService
    private init() {
        self.service = ShareService()
    }
    
    func createShareableLink(using model: ReportDataModel) async throws -> String {
        do {
            
            let reportId = model.buildReportId()
            
            print("Report ID: \(reportId)")
            
            /// Lets map
            let payload: ReportToShare = .init(
                reportId: reportId,
                title: model.report.title,
                city: model.locator.city,
                country: model.locator.country,
                description: model.report.description,
                severity: model.report.severity.title,
                issueType: model.report.issueType.title,
                status: model.report.status.title,
                coordinate: model.report.coordinate,
                cellIndex: model.report.cellIndex,
                openCodeLocation: model.report.olc ?? ""
            )

            ///
            let share = Share<ReportToShare>(payload, type: .report, lang: "es-419")
            
            ///  Lets invoke the service
            let result = try await service.createLink(for: share)
            
            /// Lets validate the incoming response to extract shareUrl
            if result.code == "SHARE_GENERATED" {
                return result.data.shareUrl
            } else {
                throw CommonIntercommunicationErrors.invalidPetition(result.code)
            }
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        }  catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.invalidPetition(error.localizedDescription)
        }
    }
}
