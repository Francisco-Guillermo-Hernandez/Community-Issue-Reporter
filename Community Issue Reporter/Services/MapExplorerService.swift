//
//  MapExplorerService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation
import SwiftMsgpack

struct MapExplorerService {
    
    private let client: ServiceClient
    init(client: ServiceClient =  ServiceClient(baseURL: Endpoints.baseURL, decoderType: .messagePack(MsgPackDecoder()))) {
        self.client = client
    }
    
    func reports(q: MapExplorerQueryParams, h: [HTTPHeader]) async throws -> MapExplorerReports {
        return try await client.get(path: "map-explorer/reports", query: q, headers: h, withOAuth: false)
    }
    
    func report(_ id: String, h: [HTTPHeader]) async throws -> MapExplorerReport {
        return try await client.get(path: "map-explorer/reports/\(id)", headers: h, withOAuth: false)
    }
}
