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
    
    var presentAlert: Bool = false
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
        self.profile = .init()
        
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
    
    func handleLogin(for session: String, with type: LoginType, _ appState: AuthViewModel) {
        if !session.isEmpty {
            if type == .guest {
                saveIntoKeychain(session)
                self.isGuest = true
            } else {
                Task {
        
                    do {
                        let (state, sessionId, data) = try await UserRepository.shared.login(session)
                        
                        self.userOAuthState = state
                        /// Validates if the first time user login
                        if state == .firstLogin {
                            self.path.append(.selectCity)
                        } else {
                            
                            if data.landingPageCompleted {
                                /// Set preferences
                                self.setSettingsFromAuthenticatedUser(with: data)
                                self.setCameraPositionByCityId(appState: appState)
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
                    } catch {
                        self.showAlert(message: String(localized: "Something went wrong"))
                    }
                    
                }
            }
        } else {
            self.showAlert(message: String(localized: "Something went wrong"))
        }
    }
    
    private func saveIntoKeychain(_ sessionId: String) {
        _ = KeychainService.save(key: .mutation, value: sessionId)
    }
    
    private func showAlert(message: String) -> Void {
        self.message = message
        self.presentAlert = true
    }
    
    private func setCameraPositionByCityId(appState: AuthViewModel) -> Void {
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
        
        _ = KeychainService.save(key: .sessionStateVerification, value: "session:state:valid")
    }
    
    private func setAvatar(url: String, _ createdFrom: AvatarCreatedFrom) -> Void {
//        self.profile.avatarURL = urlFromString(url)
        self.profile.selectedAvatarOptionView = createdFrom
    }
    
    func checkStatus() {
        isLoggedIn = UserRepository.shared.isSessionValid()
    }
    
    func logout() {
        self.isLoggedIn = false
        self.isGuest = false
        
        _ = KeychainService.deleteToken(key: .query)
        _ = KeychainService.deleteToken(key: .mutation)
        _ = KeychainService.deleteToken(key: .sessionStateVerification)
        
//            UserDefaults.standard.set(nil, forKey: "selected_city")
        
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
    }
    
}
