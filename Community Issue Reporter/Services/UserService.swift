//
//  UserService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation

struct UserService {
    private let client: ServiceClient
    
    init(client: ServiceClient = ServiceClient(baseURL: authService)) {
        self.client = client
    }
    
    func login(payload: OAuthSignInPayload) async throws -> LoginWithOAuthProviderResponse {
        return try await client.post(path: "auth/Google/tokenSignInOrLogin", body: payload)
    }
    
    func logout() {
        // TODO: implement logic to perform a logout.
    }
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    func getUser() -> String? {
        return nil
    }
    
    
}
