//
//  AppDelegate.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/6/26.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    // Shared reference accessible across the app
    static var sharedNotificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    // Success: APNs gave us a token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tokenString = tokenParts.joined()
        
        DispatchQueue.main.async {
            AppDelegate.sharedNotificationManager.deviceToken = tokenString
            print("Successfully registered device token: \(tokenString)")
        }
    }

    // Failure: APNs registration failed (e.g. simulator error or network block)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error.localizedDescription)")
    }
}
