//
//  VotingService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/8/26.
//

import Foundation

struct VotingService {
    private let client: ServiceClient
    
    init(client: ServiceClient = ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func vote(for votingType: VotingType, payload: Voting, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "voting/\(votingType.rawValue)", body: payload, headers: headers, withOAuth: true)
    }
    
    func havIVoted(for votingType: VotingType, resourceId: String, headers: [HTTPHeader]) async throws -> CustomizedResponse<VotingResolution> {
        return try await client.get(path: "voting/\(votingType.rawValue)/\(resourceId)", headers: headers, withOAuth: true)
    }
}
