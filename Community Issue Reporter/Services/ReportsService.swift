//
//  ReportsService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct ReportsService {
    private let client: ServiceClient

    init(client: ServiceClient = ServiceClient()) {
        self.client = client
    }

    func fetchReports() async throws -> [Report] {
        return try await client.get(path: "reports/", withOAuth: true)
    }

    func fetchReport(reportId: String) async throws -> Report {
        return try await client.get(path: "reports/\(reportId)", withOAuth: true)
    }
    
    func createReport(report: Report, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.post(path: "reports/create", body: report, headers: headers, withOAuth: true)
    }
    
    func deleteReport(by reportId: String) async throws -> GenericResponse {
        return try await client.delete(path: "reports/\(reportId)", body: [String: String](), headers: [],  withOAuth: true)
    }
    
    func attachPicture(reportId: String, imagesData: [Data]) async throws -> Array<GenericResponse> {
        
        let files: [MultipartFormFile] = imagesData.map { imageData in
            MultipartFormFile(
                name: "picture",
                filename: "report-picture.webp",
                mimeType: "image/webp",
                data: imageData
            )
        }
        
        return try await client.patch(
            path: "reports/\(reportId)/attach-picture",
            body: [String: String](),
            headers: [],
            formFiles: files,
            withOAuth: true,
        )
    }
    
    func fetchReportByUser(q: PaginatedRequestQueryParams) async throws -> PaginatedResponse<Report> {
        return try await client.get(path: "reports/byUser", query: q, withOAuth: true,)
    }
}
