//
//  EssentialInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/5/26.
//

import SwiftUI

struct EssentialInformationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var triggerFeedBack: Bool = false
    @Environment(NotificationManager.self) var notificationManager
    @Environment(\.mySettings) private var settings
    @Binding var notifications: Notifications
    @State private var isLoading: Bool = false
    @State private var message: String = String(localized: "Configure my account")
    @State private var isSavingNotifications: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var messageError: String = ""
    
    var finalStep: () -> Void
    var body: some View {
        ScrollView {
            VStack {
                
                /// Notifications group
                SettingsGroup(
                    title: String(localized: "Notifications"),
                    footerText: String(localized: "Please give me permission to send you notifications about status of your reports and follow up.\nyou can change these settings in the app settings."),
                    isLoading: $isSavingNotifications,
                ) {
                    Toggle("Push notifications", isOn: $notifications.app)
                        .tint(Color.theme.primary)
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
                    
                    Divider()
                        .opacity(0.67)
                    
                    Toggle("Email notifications", isOn: $notifications.email)
                        .tint(Color.theme.primary)
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
        .alert(String(localized: "Error"), isPresented: $showErrorAlert) {
            Button(role: .close) {
                
            } label: {
                Text("Ok")
            }
        } message: {
            Text(messageError)
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
            ThemedButton(
                message: message,
                action: {
                    completeLandingPage()
                    initializeStats()
                    triggerFeedBack.toggle()
                    message = String(localized: "Start reporting")
                    finalStep()
                },
                type: .secondary,
                isLoading: $isLoading
            )
            .padding(.horizontal, 36)
            .padding(.top, 0)
            .padding(.bottom, 4)
            
        }
        .sensoryFeedback(.success, trigger: triggerFeedBack)
        .background {
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.theme.secondary.mix(with: colorScheme == .dark ? .black : .white, by: 0.4).opacity(0.67),
                            Color.theme.background
                        ]),
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: geo.size.width * 0.54
                    )
                    
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func completeLandingPage() -> Void {
        Task {
            isLoading = true
            message = String(localized: "Saving my configuration")
            
            let maxRetries = 3
            for attempt in 1...maxRetries {
                do {
                    let result = try await UserRepository.shared.completeLandingPage()
                    if result == .done {
                        _ = KeychainService.save(key: .landingPageComplete, value: "completion:state:successfully")
                    }
                    break // Success, exit loop
                } catch {
                    if attempt == maxRetries {
                        show(error: String(localized: "Failed to save configuration after \(maxRetries) attempts."))
                    } else {
                        // Delay before retrying
                        try? await Task.sleep(for: .seconds(2))
                    }
                }
            }
            
            isLoading = false
        }
    }
    
    func updateNotificationSettings() {
        Task {
            
            do {
                self.isSavingNotifications = true
                try await Task.sleep(for: .milliseconds(256))
                let result = try await UserRepository.shared.modify(notifications)
                
                switch result {
                    case .success(let message):
                        print(message)

                    case .failure(let error):
                        print(error)

                }
            } catch CommonIntercommunicationErrors.unProcessable {
                self.show(error: String(localized: "Your petition cannot be processed, please try again."))
            } catch CommonIntercommunicationErrors.networkError(_) {
                self.show(error: String(localized: "It looks like that your network is experiencing some delays, please try again."))
            } catch CommonIntercommunicationErrors.serverError(_) {
                self.show(error: String(localized: "Server error, please try again."))
            } catch {
                self.show(error: String(localized: "An unexpected error has occurred, please try again."))
            }
            
            self.isSavingNotifications = false
        }
    }
    
    func initializeStats() {
        Task {
            do {
                isLoading = true
                message = String(localized: "Initializing Insights")
                _ = try await InsightsRepository.shared.initialize()
            } catch CommonIntercommunicationErrors.networkError(_) {
                self.show(error: String(localized: "It looks like that your network is experiencing some delays, please try again."))
            } catch {
             print(error)
            }
            
            isLoading = false
        }
    }
    
    func show(error: String) {
        self.messageError = error
        self.showErrorAlert = true
    }
}

#Preview {
    NavigationStack {
        
        EssentialInformationView(notifications: .constant(.init(app: false, email: false, web: false)), finalStep: {
            
        })
        .environment(NotificationManager())
    }
}
