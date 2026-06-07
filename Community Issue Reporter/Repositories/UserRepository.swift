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

typealias UserNameCompletion = (Result<String, UserError> ) -> Void
typealias UserCompletion = (Result<String, Error> ) -> Void

final class UserRepository {
    
    static var shared: UserRepository = .init()
    var service: UserService
    private init () {
        self.service = UserService()
    }
    
    func login(
        _ token: String,
        onSuccess: @escaping (UserOAuthResultState, String) -> Void,
        onError: @escaping (_ error: Error) -> Void
    ) async -> Void {
        do {
            let loginHeaders = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
            ]
            
            let result = try await self.service.login(payload: OAuthSignInPayload(token: token), headers: loginHeaders)
            
            if result.code == "TOKEN_GENERATED" {
                onSuccess(.existing, result.authSessionId)
            }
            
            if result.code == "USER_CREATED_WITH_TOKEN" {
                onSuccess(.firstLogin, result.authSessionId)
            }
        } catch {
            onError(error)
            
        }
    }
    
    func loginAsGuest(
        onSuccess: @escaping (UserOAuthResultState, String) -> Void,
        onError: @escaping (_ error: Error) -> Void
    ) async -> Void {
        do {
            let headers = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
                HTTPHeader(name: "CityId", content: "san-salvador")
            ]
            
            let result = try await self.service.loginAsGuest(headers)
            
            if result.code == "GUEST_SESSION_CREATED" {
                onSuccess(.inexistent, result.authSessionId)
            } else {
                
            }
        } catch {
            onError(error)
        }
    }
    
    func getProfilePictureURL() -> URL? {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile,
              profile.hasImage else {
            return nil
        }
        
        return profile.imageURL(withDimension: 200)
    }
    
    func getName() -> String {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile else { return "Visitor" }
        
        return profile.name
    }
    
    func getPublicInformation() -> UserProfile? {
        
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile,
              let email = user.profile?.email,
              let username = user.profile?.name,
              profile.hasImage else { return nil }
        
         
       return UserProfile(
            username: username,
            avatar: profile.imageURL(withDimension: 200),
            email: email
           
        )
    }
    
    func getAvatar() -> URL? {
        UserDefaults.standard.string(forKey: "avatar_url").flatMap(URL.init(string:))
    }
    
    func changeAvatar(_ image: UIImage, userName: String, completion: @escaping UserCompletion) async {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "UserRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])))
            return
        }
        
        do {
            let result = try await self.service.change(avatar: imageData)
            
            if result.code == "AVATAR_UPDATED" {
                completion(.success(result.message))
               
                if let avatarUrl = result.data?.avatarUrl {
                    UserDefaults.standard.set(avatarUrl, forKey: "avatar_url")
                }
                
            } else {
                throw ImageError.unknownError(result.message)
            }
            
        } catch {
            completion(.failure(error))
        }
        
    }
    
    func checkAvailability(of userName: String, completion:  @escaping UserNameCompletion) async {
        do {
            
            let headers = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
            ]
            
            let result = try await self.service.checkAvailability(of: userName, headers)
            
            if result.code == "USER_NAME_AVAILABLE" {
                completion(.success(result.message))
            }
            
        } catch ServiceError.badRequest(let genericResponse) {
            
            switch genericResponse.code {
            
                case "USER_NAME_TAKEN":
                    completion(.failure(.taken))
                case "USER_NAME_INVALID":
                    completion(.failure(.invalidUserName))
                default:
                    completion(.failure(.unknownError(genericResponse.message)))
            }

        } catch {
            completion(.failure(.unknownError(error.localizedDescription)))
        }
    }
}

enum UserError: Error {
    case invalidUserName
    case tooLarge
    case unknownError(String)
    case taken
}

enum ImageError: Error {
    case invalidData
    case tooLarge(String)
    case unknownError(String)
}
