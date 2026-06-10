//
//  EssentialInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/5/26.
//

import SwiftUI

struct EssentialInformationView: View {
    @State private var triggerFeedBack: Bool = false
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.mySettings) private var settings
    @State var notifications: Notifications = .init(app: false, email: false, web: false)

    var finalStep: () -> Void
    var body: some View {
        ScrollView {
            VStack {
                
                /// Notifications group
                SettingsGroup(title: "Notifications") {
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

            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                    .ignoresSafeArea()

                VStack {
                    ThemedButton(
                        message: String(localized: "Report Problems"),
                        action: {
                            triggerFeedBack.toggle()
                            
                            completeLandingPage()
                            finalStep()
                         
                        },
                        type: .primary
                    )
                    .padding()
                    .padding(.top, 0)
                }
                .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)

        }
        .sensoryFeedback(
            .impact(weight: .medium),
            trigger: triggerFeedBack
        )
        
    }
    
    func completeLandingPage() -> Void {
        Task {
            await UserRepository.shared.completeLandingPage(completion: {
                _ = KeychainService.save(key: .landingPageComplete, value: "completion:state:successfully")
            })
        }
    }
    
    func updateNotificationSettings() {
        Task {
            try? await Task.sleep(for: .milliseconds(550))
            await UserRepository.shared.modify(notifications, completion: { _ in
                print("updated")
            })
        }
    }
}

#Preview {
    NavigationStack {
        EssentialInformationView(finalStep: {
            
        })
        .environmentObject(NotificationManager())
    }
}
