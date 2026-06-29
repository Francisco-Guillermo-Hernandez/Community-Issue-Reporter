//
//  UserService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation

struct UserService {
    private let client: ServiceClient
    
    init(client: ServiceClient = ServiceClient(baseURL: Endpoints.apiV1)) {
        self.client = client
    }
    
    func login(payload: OAuthSignInPayload, headers: Array<HTTPHeader>) async throws -> LoginWithOAuthProviderResponse {
        return try await client.post(path: "auth/Google/tokenSignInOrLogin", body: payload, headers: headers)
    }
    
    func loginAsGuest(_ headers: Array<HTTPHeader>) async throws -> LoginWithOAuthProviderResponse {
        return try await client.post(path: "auth/guest/generate/session", body: [String: String](), headers: headers)
    }
    
    func checkAvailability(of userName: String, _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user/check/availability", body: ["userName": userName], headers: headers, withOAuth: true)
    }
    
    func modify(_ notifications: Notifications,  _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.patch(path: "user/notifications", body: notifications, headers: headers, withOAuth: true)
    }
    
    func change(_ userName: String, _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.patch(path: "user/userName", body: ["userName": userName], headers: headers, withOAuth: true)
    }
    
    func completeLandingPage() async throws -> GenericResponse {
        return try await client.patch(path: "user/landing/completed", body: [String: String](), headers: [], withOAuth: true)
    }
    
    func send(_ deviceToken: DeviceTokenRequest, _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.patch(path: "user/device/token", body: deviceToken, headers: headers, withOAuth: true)
    }
    
    func privacy(_ settings: PrivacySettings, _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.patch(path: "user/privacy", body: settings, headers: headers, withOAuth: true)
    }
    
    func change(avatar: Data, from: AvatarCreatedFrom) async throws -> CustomizedResponse<AvatarResponse> {

        let files: [MultipartFormFile] = [
            MultipartFormFile(
                name: "avatar",
                filename: "avatar.jpg",
                mimeType: "image/jpeg",
                data: avatar
            )
        ]

        return try await client.post(
            path: "user/change/avatar",
            body: AvatarCreatedFromRequest(avatarCreatedFrom: from),
            headers: [
                HTTPHeader(name: "Client-Type", content: "Mobile-App")
            ],
            formFiles: files,
            withOAuth: true,
        )
    }
}
