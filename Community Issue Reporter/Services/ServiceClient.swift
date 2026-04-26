//
//  ServiceClient.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation

struct ServiceClient {
    enum ServiceError: Error {
        case baseURLMissing
        case invalidResponse
        case httpStatus(Int)
    }

    private let baseURL: URL?
    private let session: URLSession
    private let decoder: JSONDecoder
    private let delimiter = "/"
    
    private func getOAuthHeader(t: TokenType) -> HTTPHeader {
        let token = KeychainService.getToken(t)
        return HTTPHeader(name: "Authorization", content: "Bearer \(token)")
    }

    init(baseURL: URL? = development, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = ServiceClient.makeJSONDecoder()
    }

    fileprivate func queryBuilder<Q: Encodable>(_ query: Q?, _ url: inout URL) {
        if let query = query, let dict = query.dictionary {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItems = dict.compactMap { key, value -> URLQueryItem? in
                return URLQueryItem(name: key, value: "\(value)")
            }
            components?.queryItems = queryItems
            if let updatedURL = components?.url {
                url = updatedURL
            }
        }
    }
    
    func gets<T: Decodable, Q: Encodable>(
        path: String,
        query: Q? = nil,
        headers: Array<HTTPHeader> = [],
        withOAuth: Bool = false
    ) async throws -> T {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }

        var url = baseURL.appendingPathComponent(sanitizedPath)
        
        queryBuilder(query, &url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader(t: .query)
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }
    
    func post<T: Encodable, V: Decodable>(path: String, body: T, headers: Array<HTTPHeader> = [], withOAuth: Bool = false) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }
        
        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader(t: .mutation)
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error Response Body: \(jsonString)")
            }
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }
        
        return try decoder.decode(V.self, from: data)
    }
    
    func delete<T: Encodable, V: Decodable>(path: String, body: T, headers: Array<HTTPHeader> = [], withOAuth: Bool = false) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }
        
        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader(t: .mutation)
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }
        
        return try decoder.decode(V.self, from: data)
    }
    
    func put<T: Encodable, V: Decodable>(
        path: String,
        body: T,
        headers: Array<HTTPHeader> = [],
        withOAuth: Bool = false
    ) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }
        
        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader(t: .mutation)
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error Response Body: \(jsonString)")
            }
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }
        
        return try decoder.decode(V.self, from: data)
    }
    
    func patch<T: Encodable, V: Decodable>(
        path: String,
        body: T,
        headers: [HTTPHeader] = [],
        formFiles: [MultipartFormFile] = [],
        withOAuth: Bool = false
    ) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }

        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        if formFiles.isEmpty {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let fields = try makeFormFields(from: body)
            request.httpBody = makeMultipartBody(fields: fields, files: formFiles, boundary: boundary)
        }
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader(t: .mutation)
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }

        if formFiles.isEmpty {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error Response Body: \(jsonString)")
            }
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }

        return try decoder.decode(V.self, from: data)
    }

    private func makeFormFields<T: Encodable>(from body: T) throws -> [String: String] {
        if let fields = body as? [String: String] {
            return fields
        }

        let data = try JSONEncoder().encode(body)
        let json = try JSONSerialization.jsonObject(with: data)

        if let object = json as? [String: Any] {
            var fields = [String: String]()
            var hasUnsupportedValue = false

            for (key, value) in object {
                if let stringValue = Self.stringValue(for: value) {
                    fields[key] = stringValue
                } else {
                    hasUnsupportedValue = true
                }
            }

            if !hasUnsupportedValue {
                return fields
            }
        }

        let payload = String(data: data, encoding: .utf8) ?? ""
        return payload.isEmpty ? [:] : ["payload": payload]
    }

    private func makeMultipartBody(
        fields: [String: String],
        files: [MultipartFormFile],
        boundary: String
    ) -> Data {
        var body = Data()

        for (name, value) in fields {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        for file in files {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n")
            body.appendString("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.appendString("\r\n")
        }

        body.appendString("--\(boundary)--\r\n")
        return body
    }

    private static func stringValue(for value: Any) -> String? {
        if let string = value as? String {
            return string
        }
        if let bool = value as? Bool {
            return bool ? "true" : "false"
        }
        if let number = value as? NSNumber {
            return number.stringValue
        }
        return nil
    }

    private static func makeJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase

        
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            if let date = formatter.date(from: value) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ISO-8601 date: \(value)")
        }
        
        return decoder
    }
}

struct EmptyQuery: Encodable {}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct MultipartFormFile {
    var name: String
    var filename: String
    var mimeType: String
    var data: Data
}


struct HTTPHeader {
    var name: String
    var content: String
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}


extension ServiceClient {
    
    func get<T: Decodable, Q: Encodable>(
            path: String,
            query: Q,
            headers: [HTTPHeader] = [],
            withOAuth: Bool = false
        ) async throws -> T {
           return try await gets(path: path, query: query, headers: headers, withOAuth: withOAuth)
        }
    
    func get<T: Decodable>(
            path: String,
            headers: [HTTPHeader] = [],
            withOAuth: Bool = false
        ) async throws -> T {
           return try await gets(path: path, query: nil as EmptyQuery?, headers: headers, withOAuth: withOAuth)
        }
}
