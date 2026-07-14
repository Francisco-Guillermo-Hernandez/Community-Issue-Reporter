//
//  EssentialInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/5/26.
//

import SwiftUI

struct EssentialInformationView: View {
    @State private var triggerFeedBack: Bool = false
    @Environment(NotificationManager.self) var notificationManager
    @Environment(\.mySettings) private var settings
    @Binding var notifications: Notifications
    @State private var isLoading: Bool = false

    var finalStep: () -> Void
    var body: some View {
        ScrollView {
            VStack {
                
                /// Notifications group
                SettingsGroup(title: String(localized: "Notifications"), footerText: String(localized: "")) {
                    Toggle("Push notifications", isOn: $notifications.app)
                        .foregroundStyle(Color.theme.inputText)
                        .onChange(of: notifications.app) { oldValue, newValue in
                            if oldValue != newValue {
                                notificationManager.requestAuthorization()
                            }
                            
                            if newValue == false {
                                settings.enablePushNotifications = false
                                updateNotificationSettings()
                            }
                        }
                    
                    Toggle("Email notifications", isOn: $notifications.email)
                        .foregroundStyle(Color.theme.inputText)
                        .onChange(of: notifications.email) { oldValue, newValue in
                            settings.enableEmailNotifications = newValue
                            
                            if oldValue != newValue {
                                updateNotificationSettings()
                            }
                            
                        }
                }
                
              
                Spacer()
            }
        }
        .padding(.horizontal)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(String(localized: "Notes"))
        .task {
            // Trigger permission dialog
//            notificationManager.requestAuthorization()
        }
        .onChange(of: notificationManager.isPermissionGranted) { _, _ in
            if notificationManager.isPermissionGranted {
                settings.enablePushNotifications = true
                updateNotificationSettings()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {

            BottomFadedView {
                ThemedButton(
                    message: String(localized: "Report Problems"),
                    action: {
                        completeLandingPage()
                        triggerFeedBack.toggle()
                        finalStep()
                        
                     
                    },
                    type: .primary,
                    isLoading: $isLoading
                )
                .padding()
                .padding(.top, 0)
            }
        }
        .sensoryFeedback(.success, trigger: triggerFeedBack)
        .background(Color.theme.background)
    }
    
    func completeLandingPage() -> Void {
        Task {
            do {
                isLoading = true
                let result = try await UserRepository.shared.completeLandingPage()
                if result == .done {
                    _ = KeychainService.save(key: .landingPageComplete, value: "completion:state:successfully")
                }
               
            } catch {
                // TODO: retry 
            }
            
            isLoading = false
        }
    }
    
    func updateNotificationSettings() {
        Task {
            
            do {
                try await Task.sleep(for: .milliseconds(550))
                let result = try await UserRepository.shared.modify(notifications)
                
                switch result {
                    case .success(let message):
                        print(message)

                    case .failure(let error):
                        print(error)

                }
            } catch {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        
        EssentialInformationView(notifications: .constant(.init(app: false, email: false, web: false)), finalStep: {
            
        })
        .environment(NotificationManager())
    }
}
