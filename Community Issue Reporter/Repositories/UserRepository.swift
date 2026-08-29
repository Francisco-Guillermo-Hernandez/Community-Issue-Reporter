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
    var headers: [HTTPHeader]
    private init () {
        self.service = UserService()
        self.headers = [
            HTTPHeader(name: "Client-Type", content: "Mobile-App"),
            HTTPHeader(name: "CountryCode", content: "SV"),
            HTTPHeader(name: "CityId", content: "a67b90f9-1d76-4835-a994-03cd04f1d619")
        ]
    }
    
    
    /// We are going to check if the token generated from the login process is valid
    /// then we are going to generate a session in response to that login request
    func login(_ token: String) async throws -> (UserOAuthResultState, String, PublicUserData)  {
        do {
        
            let result = try await self.service.login(payload: OAuthSignInPayload(token: token), headers: headers)
            
            if result.code == "TOKEN_GENERATED" {
                return (.existing, result.authSessionId, result.publicUserData)
            } else if result.code == "USER_CREATED_WITH_TOKEN" {
                return (.firstLogin, result.authSessionId, result.publicUserData)
            } else {
                throw CommonIntercommunicationErrors.invalidPetition(result.code)
            }
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.forbidden(let response) {
            throw CommonIntercommunicationErrors.forbidden(response)
        } catch ServiceError.serverError(let message) {
          throw CommonIntercommunicationErrors.serverError(message)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func signInOrLoginWithApple(payload: AuthPayload) async throws -> (UserOAuthResultState, String, PublicUserData)  {
        do {
        
            let result = try await self.service.signInOrLoginWithApple(payload: payload, headers: headers)
            
            if result.code == "TOKEN_GENERATED" {
                return (.existing, result.authSessionId, result.publicUserData)
            } else if result.code == "USER_CREATED_WITH_TOKEN" {
                return (.firstLogin, result.authSessionId, result.publicUserData)
            } else {
                throw CommonIntercommunicationErrors.invalidPetition(result.code)
            }
        } catch ServiceError.badRequest(let response) {
            throw CommonIntercommunicationErrors.invalidPetition(response.code)
        } catch ServiceError.forbidden(let response) {
            throw CommonIntercommunicationErrors.forbidden(response)
        } catch ServiceError.serverError(let message) {
          throw CommonIntercommunicationErrors.serverError(message)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    
    
    /// We are going to let users to report as a guests
    /// this feature offers a limited features compared to registered users
    func loginAsGuest() async throws -> (UserOAuthResultState, String) {
        do {
        
            let result = try await self.service.loginAsGuest(headers)
            
            if result.code == "GUEST_SESSION_CREATED" {
                return (.inexistent, result.authSessionId)
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    ///
    func getProfilePicture() -> String {
       return  UserDefaults.standard.string(forKey: "avatar_url") ?? ""
    }
    
    ///
    func getProfilePictureURL() -> URL? {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile,
              profile.hasImage else {
            return nil
        }
        
        return profile.imageURL(withDimension: 200)
    }
    
    ///
    func getNames() -> String {
        UserDefaults.standard.string(forKey: "names") ?? "Guest"
    }
    
    ///
    func getName() -> String {
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let profile = user.profile else {  return getNames() }
        
        return profile.name
    }
    
    ///
    func setNames(_ names: String) -> Void {
        UserDefaults.standard.set(names, forKey: "names")
    }
    
    ///
    func getUsername() -> String {
        UserDefaults.standard.string(forKey: "user_name") ?? "guest"
    }
    
    /// Save user name into user defaults
    func setUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: "user_name")
    }
    
    /// Save avatar url to user defaults
    func setAvatar(url: String) -> Void {
        UserDefaults.standard.set(url, forKey: "avatar_url")
    }
    
    
    
    ///
    func getPublicInformation(authMethod: AuthMethod) -> UserProfile? {
        
        if authMethod == .Google {
            guard let user = GIDSignIn.sharedInstance.currentUser,
                  let profile = user.profile,
                  let email = user.profile?.email,
                  let username = user.profile?.name,
                  profile.hasImage else { return nil }
            
             
           return UserProfile(
                username: username,
                avatar: profile.imageURL(withDimension: 200),
                email: email,
                profileId: ""
               
            )
        }
        
        if authMethod == .Apple {
            let email = KeychainService.getToken(.email)
            let name = KeychainService.getToken(.name)
            
            return UserProfile(
                username: name,
                avatar: urlFromString("https://development-api.reportamelo.app/avatars/1b11fcde-1fe1-1cca-11e1-111111111111.png"),
                email: email,
                profileId: ""
            )
        }
        
        return nil
    }
    
    func getAvatar() -> URL? {
        guard let urlStr = UserDefaults.standard.string(forKey: "avatar_url"), !urlStr.isEmpty else { return nil }
        if urlStr.hasPrefix("http") {
            return URL(string: urlStr)
        }
        return getURL(from: urlStr)
    }
    
    
    func changeAvatar(_ image: UIImage, _ from: AvatarCreatedFrom) async throws -> String {
        
        ///  Define your target avatar size
        let targetSize = image.downscaled(to: .init(width: 250, height: 250))
      
        /// Compress
        guard let imageData = targetSize.jpegData(compressionQuality: 0.85) else {
            throw ImageError.unknownError("Failed to get image data")
        }
        
        let result = try await self.service.change(avatar: imageData, from: from)
        
        if result.code == "AVATAR_UPDATED" {
           
            let avatarUrl = result.data.avatarUrl
            
            setAvatar(url: avatarUrl)
            return avatarUrl
            
        } else {
            throw ImageError.unknownError(result.message)
        }
    }
    
    /// Once the user name has been verified its availability we proceed to update to the user name that user types
    func change(_ userName: String, completion: @escaping UserNameCompletion) async {
        do {
           
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
    
    /// Check availability of a user name if user name has taken it's handled with an error
    func checkAvailability(of userName: String, completion:  @escaping UserNameCompletion) async {
        do {
            
            
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
    
    /// Modify notification settings
    func modify(_ notifications: Notifications) async throws -> Result<String, Error> {
        do {
            let result = try await self.service.modify(notifications, self.headers)
            
            if result.code == "NOTIFICATIONS_UPDATED" {
                return .success(result.message)
            } else {
                throw CommonIntercommunicationErrors.genericError(result.message)
            }
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Updates the state of the landing process
    func completeLandingPage() async throws -> SuccessfulResult {
        do {
            let result = try await self.service.completeLandingPage()
            if result.code == "LANDING_COMPLETED_UPDATED" {
                return .done
            } else {
                throw CommonIntercommunicationErrors.genericError(result.message)
            }
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Send device identifier in order to send push notifications
    /// Isn't stored device type or model only a hash 
    func sendDevice(_ token: String) async throws -> SuccessfulResult {
        do {
            
            let deviceId = DeviceService.shared.getDeviceId()
            let deviceToken: DeviceTokenRequest = .init(deviceToken: token, deviceId: deviceId, platform: .iOS)
            
            let result = try await self.service.send(deviceToken, headers)
            if result.code == "DEVICE_TOKEN_UPDATED" {
                return .done
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Lets check if the user has completed the landing process to not show that process again.
    func userHasCompletedLandingPage() -> Bool {
        let token = KeychainService.getToken(.deviceId)
        return token.contains("completion:state:successfully")
    }
    
    func getAuthMethod() -> AuthMethod? {
        let token = KeychainService.getToken(.authMethod)
        guard !token.isEmpty else { return nil }
        return AuthMethod(rawValue: token)
    }
    
    /// Lets check if user has a valid session
    func isSessionValid() -> Bool {
        let token = KeychainService.getToken(.sessionStateVerification)
        return !token.isEmpty && token.contains("session:state:valid")
    }
    
    /// Lets check if the current user is a guest
    func isGuestUser() -> Bool {
        let token = KeychainService.getToken(.userType)
        return token == UserType.guest.description
    }
    
    /// Let's check if a user is visiting his own profile
    func isOwnProfile(_ profileId: String) -> Bool {
        let storedProfileId = KeychainService.getToken(.profileId)
        return !storedProfileId.isEmpty && storedProfileId == profileId
    }
    
    /// Privacy settings to show or hide their profile / userName.
    func privacy(settings: PrivacySettings) async throws {
        do {
            
            let result = try await self.service.privacy(settings, headers)

            if result.code != "PRIVACY_SETTINGS_UPDATED" {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    /// Reporting settings are used to identify the preferred city or district to which reports belong.
    func updateDefaultReporting(_ cityId: String) async throws -> SuccessfulResult {
        do {
            let result = try await self.service.defaultReportingCity(DefaultReportingCity(cityId), self.headers)
            if result.code == "DEFAULT_CITY_UPDATED" {
                return .updated
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
            
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func reportUser(_ reason: BlockUserReason) async throws -> SuccessfulResult {
        do {
            let result = try await self.service.reportUser(reason: reason, headers: headers)
            if result.code == "USER_REPORTED" {
                return .updated
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func deleteMyAccount() async throws -> SuccessfulResult {
        do {
            let result = try await self.service.deleteMyAccount(headers: headers)
            if result.code == "ACCOUNT_DELETED" {
                return .updated
            } else {
                throw CommonIntercommunicationErrors.genericError(result.code)
            }
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func logout() async throws -> SuccessfulResult {
        do {
            _ = try await self.service.logout(headers: headers)
            return .deleted
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func refresh() async throws {
        do {
            _ = try await self.service.refresh(headers: headers)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func citizenProfile(id: String) async throws -> User {
        do {
            return try await self.service.citizenProfile(id: id, headers: headers)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func block(_ reason: BlockUserReason) async throws {
        do {
            _ = try await self.service.block(reason, headers: headers)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
    }
    
    func unlock(_ profileId: String) async throws {
        do {
            _ = try await self.service.unblock(profileId, headers: headers)
        } catch ServiceError.unauthorized {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.forbidden {
            throw CommonIntercommunicationErrors.notAuthorized
        } catch ServiceError.serverError(let error) {
            throw CommonIntercommunicationErrors.serverError(error)
        } catch ServiceError.networkError(let error) {
            throw CommonIntercommunicationErrors.networkError(error.localizedDescription)
        } catch {
            throw CommonIntercommunicationErrors.genericError(error.localizedDescription)
        }
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
    let isActive:    Bool
    
    init(deviceToken: String, deviceId: String, platform: DeviceType, isActive: Bool = true) {
        self.deviceToken = deviceToken
        self.deviceId = deviceId
        self.platform = platform
        self.isActive = isActive
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

enum ReportError: Error {
    case noIdentifier
    case noCityIdentifier
}


extension UIImage {
    func downscaled(to boundingSize: CGSize) -> UIImage {
        let aspectWidth = boundingSize.width / size.width
        let aspectHeight = boundingSize.height / size.height
        let scaleFactor = min(aspectWidth, aspectHeight)
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }
}
