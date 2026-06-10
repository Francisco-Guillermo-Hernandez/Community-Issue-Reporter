//
//  ServiceClient.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 8/3/26.
//

import Foundation
import SwiftMsgpack

///
enum DecoderType {
    case json(JSONDecoder)
    case messagePack(MsgPackDecoder)
}

///
enum ServiceError: Error {
    case baseURLMissing
    case invalidResponse
    case httpStatus(Int)
    case badRequest(GenericResponse)
    case unauthorized(String)
    case forbidden
    case notFound
    case notAllowed
    case notAcceptable
    case contentLengthMissing
    case unSupportedMediaType
    case unavailableForLegalReasons
    case serverError(String)
    case tooManyRequests
}

struct ServiceClient {
  
    private let baseURL: URL?
    private let session: URLSession
    private let decoder: DecoderType
    private let delimiter = "/"

    /// Previously I was using JWT to authorize the endpoints that require, but now I'm using a (BFF) Backend For Frontend so that use sessions instead
    private func getOAuthHeader() -> HTTPHeader {
        let token = KeychainService.getToken(.mutation)
        return HTTPHeader(name: "Cookie", content: "session_id=\(token)")
    }
    
    /// initialize the instance by default with .json decoderType
    init(baseURL: URL? = development, session: URLSession = .shared, decoderType: DecoderType = .json(.init())) {
        self.baseURL = baseURL
        self.session = session
        
        switch decoderType {
            case .json: self.decoder = .json(ServiceClient.makeJSONDecoder())
            case .messagePack(let customPackDecoder): self.decoder = .messagePack(customPackDecoder)
        }
    }

    /// Decoder used in with the selection
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
           switch self.decoder {
           case .json(let jsonDecoder):
               return try jsonDecoder.decode(type, from: data)
           case .messagePack(let msgPackDecoder):
               return try msgPackDecoder.decode(type, from: data)
           }
    }

    /// Prepare the query before being sent to the server based on key - value properties
    fileprivate func queryBuilder<Q: Encodable>(_ query: Q?, _ url: inout URL) {
        guard let query = query, let dict = query.dictionary else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems: [URLQueryItem] = []
        
        for (key, value) in dict {
            // Check if the value is an array
            if let arrayValue = value as? [Any] {
                // Create a query item for EACH item in the array
                let items = arrayValue.map { URLQueryItem(name: key, value: "\($0)") }
                queryItems.append(contentsOf: items)
            } else {
                // Handle regular primitive values (String, Int, Bool, etc.)
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        
        components?.queryItems = queryItems
        if let updatedURL = components?.url {
            url = updatedURL
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
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        if headers.count > 0 {
            for header in headers {
                request.setValue(header.content, forHTTPHeaderField: header.name)
            }
        }
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader()
            request.setValue(oAuthHeader.content, forHTTPHeaderField: oAuthHeader.name)
        }

        
        let (data, response) = try await NetworkManager.shared.fetchData(request: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Error Response Body: \(jsonString)")
            }
            
            print("statusCode")
            print(httpResponse.statusCode)
            print("request headers:")
            dump(request.allHTTPHeaderFields)
            print("respose headers", httpResponse.allHeaderFields)
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }
        
        
        print("status code \(httpResponse.statusCode)")
        
        return try decode(T.self, from: data)
    }
    
    func HTTPErrorHandler(for httpResponse: HTTPURLResponse, with data: Data, request: URLRequest) throws {
       
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 300...303:
            break
        case 304:
            break
        case 305...399:
            throw ServiceError.httpStatus(httpResponse.statusCode)
        case 400:
            let decoder = JSONDecoder()
            
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("Error Response Body: \(jsonString)")
            }
            
            let genericResponse = try decoder.decode(GenericResponse.self, from: data)
            throw ServiceError.badRequest(genericResponse)
        case 401:
            throw ServiceError.unauthorized("Please login")
        case 403:
            throw ServiceError.forbidden
        case 404:
            throw ServiceError.notFound
        case 405:
            throw ServiceError.notAllowed
        case 406:
            throw ServiceError.notAcceptable
        case 411:
            throw ServiceError.contentLengthMissing
        case 415:
            throw ServiceError.unSupportedMediaType
        case 429:
            throw ServiceError.tooManyRequests
        case 451:
            throw ServiceError.unavailableForLegalReasons
        case 500...599:
            throw ServiceError.serverError("Server Error")
        default:
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }

    }
    
    func post<T: Encodable, V: Decodable>(
        path: String,
        body: T,
        headers: Array<HTTPHeader> = [],
        formFiles: [MultipartFormFile] = [],
        withOAuth: Bool = false
    ) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }
        
        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        if formFiles.isEmpty {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let fields = try makeFormFields(from: body)
            request.httpBody = makeMultipartBody(fields: fields, files: formFiles, boundary: boundary)
        }
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader()
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
        
        try HTTPErrorHandler(for: httpResponse, with: data, request: request)
        
        return try decode(V.self, from: data)
    }
    
    func delete<T: Encodable, V: Decodable>(path: String, body: T, headers: Array<HTTPHeader> = [], withOAuth: Bool = false) async throws -> V {
        let sanitizedPath = path.hasPrefix(delimiter) ? String(path.dropFirst()) : path
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }
        
        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader()
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
        
        return try decode(V.self, from: data)
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
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader()
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
        
        return try decode(V.self, from: data)
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
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        if formFiles.isEmpty {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let fields = try makeFormFields(from: body)
            request.httpBody = makeMultipartBody(fields: fields, files: formFiles, boundary: boundary)
        }
        
        if withOAuth {
            let oAuthHeader = getOAuthHeader()
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

       try HTTPErrorHandler(for: httpResponse, with: data, request: request)

        return try decode(V.self, from: data)
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
        
        // Formatter with fractional seconds (e.g., 2026-05-22T20:55:00.000Z)
        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Formatter without fractional seconds (e.g., 1970-01-01T00:00:00Z)
        let standardFormatter = ISO8601DateFormatter()
        standardFormatter.formatOptions = [.withInternetDateTime]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            
            // Fractional seconds
            if let date = fractionalFormatter.date(from: value) {
                return date
            }
            // Fallback to standard ISO8601
            if let date = standardFormatter.date(from: value) {
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
