//
//  EvidenceService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/8/26.
//

import SwiftUI

struct EvidenceService {
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func publishExternalContributions(attachments: [GroupedAttachmentPayload], headers: [HTTPHeader]) async throws -> CustomizedResponse<[ReportAttachmentGrouping]> {
        return try await client.post(path: "external-contributions/group/by/container", body: attachments, headers: headers, withOAuth: true)
    }
}
