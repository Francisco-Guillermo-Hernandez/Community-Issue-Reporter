//
//  EvidenceRepository.swift
//  Community Issue Reporter
//

import Foundation

final class EvidenceRepository {
    static let shared = EvidenceRepository()
    private let evidenceService: EvidenceService
    
    var headers: [HTTPHeader]
    private init() {
        evidenceService = EvidenceService()
        headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
        ]
    }
    
    func publishExternalContributions(attachments: [GroupedAttachmentPayload]) async throws -> CustomizedResponse<[ReportAttachmentGrouping]> {
        do {
            let response = try await self.evidenceService.publishExternalContributions(
                attachments: attachments,
                headers: self.headers
            )
            
            return response
            
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.serverError(let code) {
            throw CommonIntercommunicationErrors.serverError(code)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
}
