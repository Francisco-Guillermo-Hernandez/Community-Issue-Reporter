//
//  NotificationManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/6/26.
//


import SwiftUI
import UserNotifications
internal import Combine

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    @Published var isPermissionGranted = false
    @Published var deviceToken: String = ""
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Request permissions
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    // Handle notifications when the app is actively running in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show banner and play sound even if user is looking at the app
        completionHandler([.banner, .sound, .list])
    }

    // Handle user tapping on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("User tapped notification with data: \(userInfo)")
        
        // Handle your custom deep link logic here
        completionHandler()
    }
}
