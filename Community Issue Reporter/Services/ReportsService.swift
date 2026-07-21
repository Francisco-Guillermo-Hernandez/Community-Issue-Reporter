//
//  ReportsService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

typealias StartReportResponse =  CustomizedResponse<ReportSessionResponse>

struct ReportsService {
    private let client: ServiceClient

    init(client: ServiceClient = ServiceClient()) {
        self.client = client
    }
    
    func start(headers: Array<HTTPHeader>) async throws -> StartReportResponse {
        return try await client.get(path: "reports/start", headers: headers, withOAuth: true)
    }

    func fetchReports() async throws -> [Report] {
        return try await client.get(path: "reports/", withOAuth: true)
    }

    func fetchReport(reportId: String) async throws -> Report {
        return try await client.get(path: "reports/\(reportId)", withOAuth: true)
    }
    
    func createReport(report: Report, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.post(path: "reports/create", body: report.toDao(), headers: headers, withOAuth: true)
    }
    
    func deleteReport(by reportId: String) async throws -> GenericResponse {
        return try await client.delete(path: "reports/\(reportId)", body: [String: String](), headers: [],  withOAuth: true)
    }
    
    func uploadSinglePicture(reportContainer: String, imageData: Data, onProgress: @escaping (Float) -> Void) async throws -> CustomizedResponse<AttachMediaResponse> {
        return try await client.upload(
            path: "attach-media/upload",
            onProgress: onProgress,
            headers: [
                HTTPHeader(name: "report-container", content: reportContainer),
                HTTPHeader(name: "upload-mode", content: "one-by-one")
            ],
            formFiles: [
                MultipartFormFile(
                         name: "picture",
                         filename: "report-picture.webp",
                         mimeType: "image/webp",
                         data: imageData
                )
            ],
            withOAuth: true
        )
    }
    
    func deleteTemporalPicture(_ key: String, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.delete(path: "attach-media/\(key)", body: [String: String](), headers: headers, withOAuth: true)
    }
        
    func fetchReportByUser(q: PaginatedRequestQueryParams) async throws -> PaginatedResponse<ReportDAO> {
        return try await client.get(path: "reports/byUser", query: q, headers: [], withOAuth: true,)
    }
    
    func updateReport(reportId: String, report: Report, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.patch(path: "reports/\(reportId)", body: report.toDao(), headers: headers, withOAuth: true)
    }
    
    func submitGroupedAttachments(attachments: [GroupedAttachmentPayload], headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.post(path: "report-attachments/group/by/container", body: attachments, headers: headers, withOAuth: true)
    }
}
