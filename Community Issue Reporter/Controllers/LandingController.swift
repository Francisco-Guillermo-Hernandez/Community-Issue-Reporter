//
//  LandingController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/6/26.
//

import SwiftUI
import Observation
import SwiftData

@MainActor
@Observable
final class LandingController {
    
    static var shared = LandingController()
    
    var accountDeleted: Bool = false
    var userPersonalizationDataModel: UserPersonalizationDataModel
    var notifications: Notifications
    var presentAlert: Bool
    var alertTitle: String = String(localized: "Error")
    var message: String = ""
    var path: [LandingNavigation] = []
    var isGuest: Bool = false
    var isLoggedIn: Bool = false
    var isCheckingStatus: Bool = false
    var userOAuthState: UserOAuthResultState = .unowned
    var selectedCity: FriendlyCityDistribution
    var countryCode: CountryCode = .SV
    private var settings: SettingsStore?
    var profile: ProfileDataModel
    init() {
        self.userPersonalizationDataModel = .init()
        self.notifications = .init(app: false, email: false, web: false)
        self.profile = .init()
        self.presentAlert = false
        selectedCity = .init(
            cityId: "a67b90f9-1d76-4835-a994-03cd04f1d619",
            firstLevel: "El Salvador",
            secondLevel: "San Salvador",
            thirdLevel: "San Salvador",
            ZipCode: "1101",
            legalGroupName: "Distrito de San Salvador",
            coordinates: .init(lat: 13.701270, lng: -89.224432),
            isCapitalCity: 1,
            isDepartmentalCapital: 1
        )
    }
    
    func inject(_ settings: SettingsStore) {
        self.settings = settings
    }
    
    func handleLogin(for payload: AuthPayload, with type: LoginType, _ appState: AuthViewModel) {
        if !payload.token.isEmpty {
            if type == .guest {
                saveIntoKeychain(payload.token)
                self.isGuest = true
            } else {
                
                if type == .user(authMethod: .Apple) {
                    performLoginActionsWithAppleProvider(payload, appState)
                }
                
                if type == .user(authMethod: .Google) {
                    performLoginActionsWithGoogleProvider(payload.token, appState)
                }
            }
        } else {
            self.showAlert(message: String(localized: "Something went wrong"))
        }
    }
    
    private func performLoginActionsWithAppleProvider(_ payload: AuthPayload, _ appState: AuthViewModel) -> Void {
        Task {
            do {
                
                /// Lets check if its the first login attempt and lets set email
                if let email = payload.email, !email.isEmpty {
                    _ = KeychainService.save(key: .email, value: email)
                }
                
                /// Lets check if its the first login attempt and lets set  name
                if let name = payload.name, !name.isEmpty {
                    _ = KeychainService.save(key: .name, value: name)
                }
                
                _ = KeychainService.save(key: .authMethod, value: AuthMethod.Apple.rawValue)
                
                ///
                let (state, sessionId, data) = try await UserRepository.shared.signInOrLoginWithApple(payload: payload)
                
                self.userOAuthState = state
                /// Validates if the first time user login
                if state == .firstLogin {
                    self.setIntoKeychain(data)
                    self.path.append(.selectCity)
                } else {
                    
                    if data.landingPageCompleted {
                        /// Set preferences
                        self.setSettingsFromAuthenticatedUser(with: data)
                        self.setCameraPositionByCityId(appState)
                        await SubscriptionManager.shared.performUserLogin(data.userId)
                        self.isLoggedIn = true
                    } else {
                        
                        /// Uncompleted landing process
                        self.path.append(.selectCity)
                    }
                    
                }
                
                self.saveIntoKeychain(sessionId)
                
            } catch CommonIntercommunicationErrors.invalidPetition(let code) {
                self.showAlert(message: "CLNT: \(code)")
            } catch CommonIntercommunicationErrors.serverError(let code) {
                self.showAlert(message: String(localized: "SVR: \(code)"))
            } catch CommonIntercommunicationErrors.networkError(let error) {
                self.showAlert(message: String(localized: "There was a problem with the network: \(error)"))
            } catch CommonIntercommunicationErrors.forbidden(let response) {
                self.showAlert(title: response.code, message: response.message)
            } catch {
                self.showAlert(message: String(localized: "Something went wrong"))
            }
            
            LoginController.shared.performLoginActions()
        }
    }
    
    private func performLoginActionsWithGoogleProvider(_ session: String, _ appState: AuthViewModel) -> Void {
        Task {
            
            do {
                let (state, sessionId, data) = try await UserRepository.shared.login(session)
                
                _ = KeychainService.save(key: .authMethod, value: AuthMethod.Google.rawValue)
                
                self.userOAuthState = state
                /// Validates if the first time user login
                if state == .firstLogin {
                    self.setIntoKeychain(data)
                    self.path.append(.selectCity)
                } else {
                    
                    if data.landingPageCompleted {
                        /// Set preferences
                        self.setSettingsFromAuthenticatedUser(with: data)
                        self.setCameraPositionByCityId(appState)
                        await SubscriptionManager.shared.performUserLogin(data.userId)
                        self.isLoggedIn = true
                    } else {
                        
                        /// Uncompleted landing process
                        self.path.append(.selectCity)
                    }
                    
                }
                
                self.saveIntoKeychain(sessionId)
                
            } catch CommonIntercommunicationErrors.invalidPetition(let code) {
                self.showAlert(message: "CLNT: \(code)")
            } catch CommonIntercommunicationErrors.serverError(let code) {
                self.showAlert(message: String(localized: "SVR: \(code)"))
            } catch CommonIntercommunicationErrors.networkError(let error) {
                self.showAlert(message: String(localized: "There was a problem with the network: \(error)"))
            } catch CommonIntercommunicationErrors.forbidden(let response) {
                self.showAlert(title: response.code, message: response.message)
            } catch {
                self.showAlert(message: String(localized: "Something went wrong"))
            }
            
            LoginController.shared.performLoginActions()
            
        }
    }
    
    private func saveIntoKeychain(_ sessionId: String) {
        _ = KeychainService.save(key: .mutation, value: sessionId)
    }
    
    private func showAlert(title: String = String(localized: "Error"), message: String) -> Void {
        self.alertTitle = title
        self.message = message
        self.presentAlert = true
    }
    
    private func setCameraPositionByCityId(_ appState: AuthViewModel) -> Void {
        if let settings = settings {
            if let container = SwiftDataLocatorDAO.shared.container {
                let context = container.mainContext
                if let city = SwiftDataLocatorDAO.shared.findCityBy(
                    cityId: settings.cityId,
                    countryCode: settings.countryCode,
                    in: context
                ) {
                    
                    appState.selectedCity = FriendlyCityDistribution(
                        cityId: city.cityId,
                        firstLevel: city.firstLevel ?? "",
                        secondLevel: city.secondLevel ?? "",
                        thirdLevel: city.thirdLevel ?? "",
                        ZipCode: city.zipCode,
                        legalGroupName: city.legalGroupName ?? "",
                        coordinates: .init(city.lat, city.lng),
                        isCapitalCity: 0,
                        isDepartmentalCapital: 0,
                        groupingId: city.groupingId,
                        groupingName: city.groupingName
                    )
                    
                    appState.setCameraPosition(
                        to: .init(lat: city.lat, lng: city.lng),
                        latitudeDelta:  0.005738743213994368,
                        longitudeDelta: 0.003718218254761041,
                    )
                }
            }
        }
    }
    
    private func setIntoKeychain(_ data: PublicUserData) -> Void {
        _ = KeychainService.save(key: .userId, value: data.userId)
        _ = KeychainService.save(key: .profileId, value: data.profileId)
        _ = KeychainService.save(key: .userType, value: data.userType.description)
        _ = KeychainService.save(key: .planType, value: PlanType.freemium.rawValue)
    }
    
    private func setSettingsFromAuthenticatedUser(with data: PublicUserData) -> Void {
        
        /// Personalization settings
        UserRepository.shared.setUsername(data.userName)
        UserRepository.shared.setNames(data.names)
        UserRepository.shared.setAvatar(url: data.profilePicture)
        setAvatar(url: data.profilePicture, data.settings.avatarCreatedFrom)
        
        /// Notification settings
        settings?.enableEmailNotifications = data.settings.notifications.email
        settings?.enableWebNotifications = data.settings.notifications.web
        
        /// Privacy settings
        settings?.showMyProfile = data.settings.privacySettings.showMyProfile
        settings?.showMyUseNameWhenShare = data.settings.privacySettings.showMyUseNameWhenShare
        
        /// Reporting settings
        settings?.countryCode = data.settings.reportLocatorSettings.countryCode
        settings?.cityId = data.settings.reportLocatorSettings.cityId
        
        /// Set values into device keychain
        setIntoKeychain(data)
        _ = KeychainService.save(key: .sessionStateVerification, value: "session:state:valid")
        
    }
    
    private func setAvatar(url: String, _ createdFrom: AvatarCreatedFrom) -> Void {
        self.profile.selectedAvatarOptionView = createdFrom
        
        if createdFrom == .GoogleAuth {
            UserRepository.shared.setAvatar(url: url)
        }
    }
    
    func checkStatus() {
        isLoggedIn = UserRepository.shared.isSessionValid()
    }
    
    func logout() {
        UserRepository.shared.signOutFromGoogle()
        AuthViewModel.shared.selectedCity = nil
        
        /// Remove values from devices' keychain
        ///
        _ = KeychainService.deleteToken(key: .name)
        _ = KeychainService.deleteToken(key: .email)
        _ = KeychainService.deleteToken(key: .query)
        _ = KeychainService.deleteToken(key: .userId)
        _ = KeychainService.deleteToken(key: .deviceId)
        _ = KeychainService.deleteToken(key: .planType)
        _ = KeychainService.deleteToken(key: .mutation)
        _ = KeychainService.deleteToken(key: .userType)
        _ = KeychainService.deleteToken(key: .profileId)
        _ = KeychainService.deleteToken(key: .authMethod)
        _ = KeychainService.deleteToken(key: .landingPageComplete)
        _ = KeychainService.deleteToken(key: .sessionStateVerification)
        
        
        let selectedOptionKey = "selected_avatar_option"
        let selectedColorKey = "selected_avatar_color"
        UserDefaults.standard.set(nil, forKey: selectedOptionKey)
        UserDefaults.standard.set(nil, forKey: selectedColorKey)
        UserDefaults.standard.set(nil, forKey: "map_latitude_delta")
        UserDefaults.standard.set(nil, forKey: "map_longitude_delta")
        UserDefaults.standard.set(nil, forKey: "avatar_url")
        UserDefaults.standard.set(nil, forKey: "user_name")
        UserDefaults.standard.set(nil, forKey: "names")
        UserDefaults.standard.set(nil, forKey: "selectedLanguageCode")
        UserDefaults.standard.set(nil, forKey: "selected_city")
        UserDefaults.standard.set(nil, forKey: "map_latitude")
        UserDefaults.standard.set(nil, forKey: "map_longitude")
        UserDefaults.standard.set(nil, forKey: "cityId")
        UserDefaults.standard.set(nil, forKey: "countryCode")
        UserDefaults.standard.set(nil, forKey: "enableEmailNotifications")
        UserDefaults.standard.set(nil, forKey: "showMyUseNameWhenShare")
        UserDefaults.standard.set(nil, forKey: "enableEmailNotifications")
        
        print("[UserDefaults] - Cleared user data from UserDefaults]")
        
        /// route to login view
        self.isLoggedIn = false
        self.isGuest = false
        self.path.removeAll()
        
        Task {
            await SubscriptionManager.shared.handleUserLogout()
        }
    }
    
}
