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

    var showDeleteAlert: Bool = false
    var showActiveSubscriptionAlert = false
    var showManageSubscriptions = false
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
    var isDeletingAccount: Bool = false
    
    var updatingPrivacySettingsLoading: Bool = false
    var updatingNotificationSettingsLoading: Bool = false
    
    
    func inject(_ settings: SettingsStore, _ notificationManager: NotificationManager) {
        self.settings = settings
        self.notificationManager = notificationManager
    }

    var isPrivacySettingsUpdated: Bool = false
    func updatePrivacySettings() {
        Task {
            do {
                
                guard let settings else { return }
                
                self.updatingPrivacySettingsLoading = true
                /// Debouncing
                try await Task.sleep(for: .milliseconds(128))
                try await UserRepository.shared.privacy(
                    settings: .init(
                        showMyProfile: settings.showMyProfile,
                        showMyUseNameWhenShare: settings.showMyUseNameWhenShare
                    )
                )
                
                /// Refresh token
                try await UserRepository.shared.refresh()
                isPrivacySettingsUpdated = true
                
            } catch CommonIntercommunicationErrors.networkError(let error) {
                showNetworkError = true
            } catch {
                print(error)
            }
            self.updatingPrivacySettingsLoading = false
            self.isPrivacySettingsUpdated = false
        }
    }
    
    var isNotificationSettingsUpdated: Bool = false
    func updateNotificationSettings() {
        Task {
            
            do {
                guard let settings else { return }
                self.updatingNotificationSettingsLoading = true
                
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
                    try await UserRepository.shared.refresh()
                    isNotificationSettingsUpdated = true
                    Toast.shared.show(message: message, type: .info)
                    
                    print(message)
                    
                case .failure(let error):
                    print(error)
                    
                }
            } catch CommonIntercommunicationErrors.networkError {
                showNetworkError = true
            } catch {
                print(error)
            }
            
            isNotificationSettingsUpdated = true
            self.updatingNotificationSettingsLoading = false
        }
    }
    
    var isDeviceTokenUpdated: Bool = false
    func updateDeviceToken() {
        Task {
            
            do {
                guard let notificationManager = notificationManager, !notificationManager.deviceToken.isEmpty else { return }
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
    
    func deleteAccount() async {
        do {
            isDeletingAccount = true
            _ = try await UserRepository.shared.deleteMyAccount()
        } catch CommonIntercommunicationErrors.networkError {
            showNetworkError = true
        } catch {
            print("Failed to delete account: \(error)")
        }
        
        isDeletingAccount = false
    }
    
    
    func handleDeleteRequest(isPro: Bool) {
        /// Validate against the 'isPro' property you already set up
        if isPro {
            showActiveSubscriptionAlert = true
        } else {
            /// No active subscription, safe to prompt for deletion
            showDeleteAlert = true
        }
    }
}
