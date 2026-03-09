//
//  ReportsService.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
//

import Foundation

struct ReportsService {
    private let client: ServiceClient

    init(client: ServiceClient = ServiceClient()) {
        self.client = client
    }

    func fetchReports() async throws -> [Report] {
        return try await client.get(path: "reports")
    }

    func fetchReport(reportId: String) async throws -> Report {
        return try await client.get(path: "reports/\(reportId)")
    }
}
