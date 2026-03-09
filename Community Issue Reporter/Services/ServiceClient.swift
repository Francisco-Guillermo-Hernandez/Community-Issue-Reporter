//
//  ServiceClient.swift
//  Community Issue Reporter
//
//  Created by Codex on 8/3/26.
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

    init(baseURL: URL? = development, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = ServiceClient.makeJSONDecoder()
    }

    func get<T: Decodable>(path: String) async throws -> T {
        let sanitizedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let baseURL else {
            throw ServiceError.baseURLMissing
        }

        let url = baseURL.appendingPathComponent(sanitizedPath)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.httpStatus(httpResponse.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }

    private static func makeJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
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
