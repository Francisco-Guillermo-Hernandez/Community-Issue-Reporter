//
//  SettingsSubViewController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/7/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SettingsSubViewController {

    var selectedCity: FriendlyCityDistribution = .init(
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
    
    private var settings: SettingsStore?
    private var notificationManager: NotificationManager?
    var showNetworkError: Bool = false
    
    func inject(_ settings: SettingsStore, _ notificationManager: NotificationManager) {
        self.settings = settings
        self.notificationManager = notificationManager
    }

    var isPrivacySettingsUpdated: Bool = false
    func updatePrivacySettings() {
        Task {
            print("update privacy settings")
            do {
                
                guard let settings else { return }
                
                /// Debouncing
                try await Task.sleep(for: .milliseconds(128))
                try await UserRepository.shared.privacy(
                    settings: .init(
                        showMyProfile: settings.showMyProfile,
                        showMyUseNameWhenShare: settings.showMyUseNameWhenShare
                    )
                )
                
                isPrivacySettingsUpdated = true
            } catch CommonIntercommunicationErrors.networkError(let error) {
                print(error)
                showNetworkError = true
            } catch {
                
            }
            
            isPrivacySettingsUpdated = false
        }
    }
    
    var isNotificationSettingsUpdated: Bool = false
    func updateNotificationSettings() {
        Task {
            
            do {
                guard let settings else { return }
                
                try await Task.sleep(for: .milliseconds(128))
                let result = try await UserRepository.shared.modify(
                    .init(
                        app: settings.enablePushNotifications,
                        email: settings.enableEmailNotifications,
                        web: settings.enableWebNotifications
                    )
                )
                
                switch result {
                case .success(let message):
                    isNotificationSettingsUpdated = true
                    print(message)
                    
                case .failure(let error):
                    print(error)
                    
                }
            } catch CommonIntercommunicationErrors.networkError {
                showNetworkError = true
            } catch {
                
            }
            
            isNotificationSettingsUpdated = true
        }
    }
    
    var isDeviceTokenUpdated: Bool = false
    func updateDeviceToken() {
        Task {
            
            do {
                guard let notificationManager else { return }
                _ = try await UserRepository.shared.sendDevice(notificationManager.deviceToken)
                
                isDeviceTokenUpdated = true
            } catch CommonIntercommunicationErrors.networkError {
                showNetworkError = true
            } catch {
                print(error)
            }
            
            isDeviceTokenUpdated = true
        }
    }
}
