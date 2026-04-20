//
//  UserRepository.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation
import GoogleSignIn

enum UserOAuthResultState {
    case firstLogin
    case existing
    case disabled
    case inexistent
    case unowned 
}

struct UserRepository {
    
    static func login(
        _ token: String,
        onSuccess: @escaping (UserOAuthResultState, UserTokens) -> Void,
        onError: @escaping (_ error: Error) -> Void
    ) async -> Void {
        do {
            let result = try await UserService().login(payload: OAuthSignInPayload(token: token))
            
            if result.code == "TOKEN_GENERATED" {
                onSuccess(.existing, result.authToken)
            }
            
            if result.code == "USER_CREATED_WITH_TOKEN" {
                onSuccess(.firstLogin, result.authToken)
            }
        } catch {
            onError(error)
            
        }
    }
    
    static func loginAsVisitor(
        onSuccess: @escaping (UserOAuthResultState, UserTokens) -> Void,
        onError: @escaping (_ error: Error) -> Void
    ) async -> Void {
        do {
            let result = try await UserService().loginAsVisitor()
            
            onSuccess(.inexistent, result.authToken)
        } catch {
            onError(error)
        }
    }
    
    static func getProfilePictureURL() -> URL? {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile,
              profile.hasImage else {
            return nil
        }
        
        return profile.imageURL(withDimension: 100)
    }
    
    static func getName() -> String {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile else { return "Visitor" }
        
        return profile.name
    }
}
