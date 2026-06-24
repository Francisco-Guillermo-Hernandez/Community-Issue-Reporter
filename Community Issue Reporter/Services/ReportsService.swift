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
        return try await client.post(path: "reports/create", body: report, headers: headers, withOAuth: true)
    }
    
    func deleteReport(by reportId: String) async throws -> GenericResponse {
        return try await client.delete(path: "reports/\(reportId)", body: [String: String](), headers: [],  withOAuth: true)
    }
    
    func uploadSinglePicture(reportId: String, imageData: Data, onProgress: @escaping (Float) -> Void) async throws -> String {
        var request = URLRequest(url: URL(string: "http://192.168.8.204:2121/api/v1/attach-media/upload")!)
        request.httpMethod = "POST"
      
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("8e2d458a-8f85-4d92-a220-c19fa6d89883", forHTTPHeaderField: "report-container")
        request.setValue("one-by-one", forHTTPHeaderField: "upload-mode")
        
        let file = MultipartFormFile(
            name: "picture",
            filename: "report-picture.webp",
            mimeType: "image/webp",
            data: imageData
        )
        
        let delegate = UploadProgressDelegate(onProgress: onProgress)
        
        let body = client.makeMultipartBody(fields: [:], files: [file], boundary: boundary)
        
        // The delegate will report progress as bytes are sent
        let (responseData, response) = try await URLSession.shared.upload(
            for: request,
            from: body,
            delegate: delegate
        )
        
        print("response:")
        dump(response)
        print("responseData:")
        dump(responseData)
        
        
        
        if let jsonString = String(data: responseData, encoding: .utf8) {
            print("Error Response Body: \(jsonString)")
        }
        
        return UUID().uuidString // Placeholder
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
        return try await client.get(path: "reports/byUser", query: q, headers: [], withOAuth: true,)
    }
    
    func updateReport(reportId: String, report: Report, headers: Array<HTTPHeader>) async throws -> GenericResponse {
        return try await client.patch(path: "reports/\(reportId)", body: report, headers: headers, withOAuth: true)
    }
}
