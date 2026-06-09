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

    var finalStep: () -> Void
    var body: some View {
        VStack {
            Text("Some information ")
                .alert("Important Update", isPresented: .constant(false)) {
                           Button("Delete", role: .destructive) {
                               // Handle destructive action
                           }
                           Button("Cancel", role: .cancel) { } // Automatically dismisses
                       } message: {
                           Text("Are you sure you want to permanently delete this item?")
                       }
            Spacer()
        }
        .onAppear {
                            // Trigger permission dialog on app launch
                            notificationManager.requestAuthorization()
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
}

#Preview {
    EssentialInformationView(finalStep: {
        
    })
    .environmentObject(NotificationManager())
}
