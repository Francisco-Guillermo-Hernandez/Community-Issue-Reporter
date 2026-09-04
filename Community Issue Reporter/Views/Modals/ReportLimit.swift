//
//  ReportLimit.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/9/26.
//

import SwiftUI
import RevenueCatUI

struct ReportLimit: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isPresentingPaywall: Bool = false
    @State private var subscriptionManager = SubscriptionManager.shared
    
    var continuationHandler: (InteractionType) -> Void
    var body: some View {
        NavigationStack {
            
            VStack(spacing: .themeSpacing * 2) {
                Image(systemName: "clock.arrow.trianglehead.clockwise.rotate.90.path.dotted")
                    .font(.system(size: 64))
                    .symbolColorRenderingMode(.gradient)
                    .foregroundStyle(
                        Color.theme.primary,
                        Color.theme.foreground.opacity(0.7),
                        Color.white
                    )
                    .padding(.bottom, .themeSpacing * 2)
                
                Text(String(localized: "You have reached your free limit!"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(String(localized: "Thank you for using our App, you have reached the free limit for this month but you can choose to see an ad or pay a monthly subscription."))
                    .font(.body)
                    .foregroundColor(.secondary)
                    
            }
            .presentationBackground(Color.theme.background)
            .frame(maxHeight: .infinity, alignment: .top)
            .presentationDetents([.fraction(0.64)])
            .presentationBackgroundInteraction(.disabled)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 36)
        }
        .presentationBackgroundInteraction(.disabled)
        .safeAreaInset(edge: .bottom, spacing: .themeSpacing * 2) {
            VStack(spacing: .themeSpacing * 3) {
                
                if !UserRepository.shared.isGuestUser() {
                    ThemedButton(
                        message: String(localized: "Subscribe"),
                        action: {
                            isPresentingPaywall = true
                        },
                        type: .secondary,
                        style: .prominent,
                        icon: "",
                        isLoading: $isLoading
                    )
                    .accessibilityIdentifier("SubscribeButton")
                    .frame(maxHeight: 44)
                }
                
                ThemedButton(
                    message: String(localized: "View an Ad"),
                    action: {
                        isLoading = true
                        checkAdMobDomainStatus { isReachable, error in
                            DispatchQueue.main.async {
                                if isReachable {
                                    Task {
                                        let adUnitID = Bundle.main.object(forInfoDictionaryKey: "ADMOB_VIEW_AD_TO_REPORT_A_PROBLEM") as? String ?? ""
                                        let isAdLoaded = await AdMobManager.shared.loadRewardedAd(adUnitID: adUnitID)
                                        
                                        DispatchQueue.main.async {
                                            if isAdLoaded {
                                                AdMobManager.shared.showRewardedAd {
                                                    isLoading = false
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    continuationHandler(.viewAd)
                                                }
                                            } else {
                                                isLoading = false
                                                alertMessage = String(localized: "No ad is available to show right now. Please try again later.")
                                                showAlert = true
                                            }
                                        }
                                    }
                                } else {
                                    isLoading = false
                                    alertMessage = String(localized: "Cannot connect to ad server. Please check your internet connection or try again later.")
                                    showAlert = true
                                }
                            }
                        }
                    },
                    type: .outline,
                    style: .prominent,
                    icon: "",
                    isLoading: $isLoading
                )
                .accessibilityIdentifier("ViewAdButton")
                .frame(maxHeight: 44)
                
                ThemedButton(
                    message: String(localized: "No, Thanks"),
                    action: {
                        continuationHandler(.noThanks)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    },
                    type: .outline,
                    style: .prominent,
                    icon: "",
                    isLoading: $isLoading
                )
                .accessibilityIdentifier("NoThanksButton")
                .frame(maxHeight: 44)
                
                #if DEBUG
                ThemedButton(
                    message: String(localized: "Reset"),
                    action: {
                        SettingsStore.shared.reportsCount = 0
                        continuationHandler(.noThanks)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    },
                    type: .outline,
                    style: .prominent,
                    icon: "",
                    isLoading: $isLoading
                )
                .accessibilityIdentifier("ResetButton")
                .frame(maxHeight: 44)
                #endif
            }
            .padding(.horizontal, 36)
        }
        .alert(String(localized: "Notice"), isPresented: $showAlert) {
            Button(String(localized: "OK"), role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $isPresentingPaywall) {
            PaywallView()
        }
        .onChange(of: subscriptionManager.isPro) { oldValue, newValue in
            if newValue {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                isPresentingPaywall = false
                continuationHandler(.paidASubscription)
            }
        }
    }
}

#Preview {
    
    @Previewable @State var showSheet: Bool = false
    Button {
        showSheet.toggle()
    } label: {
        Text("Open")
    }
    .sheet(isPresented: $showSheet) {
        ReportLimit() { _ in
            
        }
    }
}
