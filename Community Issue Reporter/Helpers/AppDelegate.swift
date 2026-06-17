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

    // Success: APNs gave us a token try? await Task.sleep(for: .milliseconds(450))
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        
        Task {
            AppDelegate.sharedNotificationManager.deviceToken = token
            print("Successfully registered device token: \(token)")
            
            do {
               _ = try await UserRepository.shared.sendDevice(token)
            } catch {
                print(error)
            }
        }
        
    }

    // Failure: APNs registration failed (e.g. simulator error or network block)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error.localizedDescription)")
    }
}
