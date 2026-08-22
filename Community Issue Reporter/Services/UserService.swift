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
    
    func signInOrLoginWithApple(payload: AuthPayload, headers: [HTTPHeader]) async throws -> LoginWithOAuthProviderResponse {
        return try await client.post(path: "auth/Apple/tokenSignInOrLogin", body: payload, headers: headers, withOAuth: true)
    }
    
    func refresh(headers: [HTTPHeader]) async throws {
        let _: EmptyResponse = try await client.get(path: "auth/refresh/token", headers: headers, withOAuth: true)
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
    
    func defaultReportingCity(_ payload: DefaultReportingCity, _ headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.patch(path: "user/default/city", body: payload, headers: headers, withOAuth: true)
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
    
    func reportUser(reason: BlockUserReason, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user/report/reason", body: reason, headers: headers, withOAuth: true)
    }
    
    func deleteMyAccount(headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.delete(path: "user/my-account", body: [String : String](), headers: headers, withOAuth: true)
    }
    
    func logout(headers: [HTTPHeader]) async throws {
        let _: EmptyResponse = try await client.delete(path: "auth/logout", body: [String : String](), headers: headers, withOAuth: true)
    }
    
    func citizenProfile(id: String, headers: [HTTPHeader]) async throws -> User {
        return try await client.get(path: "user/citizen/\(id)", headers: headers, withOAuth: true)
    }
    
    
    /// Block users
    func block(_ reason: BlockUserReason, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.post(path: "user/blocked-users/", body: reason, headers: headers, withOAuth: true)
    }
    
    func listBlockedUsers(_ headers: [HTTPHeader]) async throws -> [User] {
        return try await client.get(path: "user/blocked-users/", headers: headers, withOAuth: true)
    }
    
    func unblock(_ profileId: String, headers: [HTTPHeader]) async throws -> GenericResponse {
        return try await client.delete(path: "user/blocked-users/\(profileId)", body: [String: String](), headers: headers, withOAuth: true)
    }
    
}
