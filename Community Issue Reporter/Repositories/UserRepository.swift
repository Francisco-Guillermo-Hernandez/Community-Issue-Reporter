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
        onSuccess: @escaping (UserOAuthResultState, String, PublicUserData) -> Void,
        onError: @escaping (_ error: Error) -> Void
    ) async -> Void {
        do {
            let loginHeaders = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
            ]
            
            let result = try await self.service.login(payload: OAuthSignInPayload(token: token), headers: loginHeaders)
            
            if result.code == "TOKEN_GENERATED" {
                onSuccess(.existing, result.authSessionId, result.publicUserData)
            }
            
            if result.code == "USER_CREATED_WITH_TOKEN" {
                onSuccess(.firstLogin, result.authSessionId, result.publicUserData)
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
    
    func getProfilePicture() -> String {
       return  UserDefaults.standard.string(forKey: "avatar_url") ?? ""
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
              let profile = user.profile else { return "Guest" }
        
        return profile.name
    }
    
    func getUsername() -> String {
        UserDefaults.standard.string(forKey: "user_name") ?? "guest"
    }
    
    func setUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: "user_name")
    }
    
    func setAvatar(url: String) -> Void {
        UserDefaults.standard.set(url, forKey: "avatar_url")
    }
    
    ///
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
                    setAvatar(url: avatarUrl)
                }
                
            } else {
                throw ImageError.unknownError(result.message)
            }
            
        } catch {
            completion(.failure(error))
        }
        
    }
    
    func change(_ userName: String, completion: @escaping UserNameCompletion) async {
        do {
            let headers = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
            ]
            
            let result = try await self.service.change(userName, headers)
            
            if result.code == "USER_NAME_UPDATED" {
                completion(.success(result.message))
            }
        } catch ServiceError.badRequest(let genericResponse) {
            switch genericResponse.code {
                case "UPDATE_NAME_ERROR":
                    completion(.failure(.serverError(genericResponse.message)))
    
                default:
                    completion(.failure(.unknownError(genericResponse.message)))
            }
        } catch {
            completion(.failure(.unknownError(error.localizedDescription)))
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
    
    func modify(_ notifications: Notifications, completion : @escaping (Result<String, Error>) -> Void) async {
        do {
            let result = try await self.service.modify(notifications, [])
            
            if result.code == "NOTIFICATIONS_UPDATED" {
                completion(.success(result.message))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func completeLandingPage(completion: @escaping () -> Void) async {
        do {
            let result = try await self.service.completeLandingPage()
            if result.code == "LANDING_COMPLETED_UPDATED" {
                completion()
            }
        } catch {
            
        }
    }
    
    
    func sendDevice(_ token: String, completion: @escaping () -> Void) async {
        do {
            let headers = [
                HTTPHeader(name: "Client-Type", content: "Mobile-App"),
                HTTPHeader(name: "CountryCode", content: "SV"),
            ]
            
            let deviceId = DeviceService.shared.getDeviceId()
            print("deviceId: \(deviceId)")
            let deviceToken: DeviceTokenRequest = .init(deviceToken: token, deviceId: deviceId, platform: .iOS)
            
            let result = try await self.service.send(deviceToken, headers)
            if result.code == "DEVICE_TOKEN_UPDATED" {
                completion()
            }
        } catch {
            
        }
    }
    
    func userHasCompletedLandingPage() -> Bool {
        let token = KeychainService.getToken(.deviceId)
        return token.contains("completion:state:successfully")
    }
    
    func setSettingsFromAuthenticatedUser(with data: PublicUserData) -> Void {
        setUsername(data.userName)
        setAvatar(url: data.profilePicture)
        print("user has been set")
        print(data.profilePicture)
    }
    
    
}

enum DeviceType: String, Decodable, Encodable {
    case iOS = "ios"
    case android = "android"
    case web = "web"
}

struct DeviceTokenRequest: Encodable, Decodable {
    let deviceToken: String
    let deviceId:    String
    let platform:    DeviceType
    
    init(deviceToken: String, deviceId: String, platform: DeviceType) {
        self.deviceToken = deviceToken
        self.deviceId = deviceId
        self.platform = platform
    }
}

enum NetworkError: Error {
    case noNetwork
    case noData
    case unavailable
    case unknown
}

enum UserError: Error {
    case invalidUserName
    case tooLarge
    case unknownError(String)
    case taken
    case serverError(String)
}

enum ImageError: Error {
    case invalidData
    case tooLarge(String)
    case unknownError(String)
}
