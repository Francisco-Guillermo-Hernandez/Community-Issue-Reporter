//
//  MonetizationManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/8/26.
//

import UIKit
internal import Combine
import AdSupport
import Foundation
import RevenueCat
import Observation
import RevenueCatAdMob
import AppTrackingTransparency
import GoogleMobileAds

@MainActor
@Observable
final class MonetizationManager {
    
    static let shared = MonetizationManager()
    
    var trackingStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        /// 1. Observe app active state to catch tracking prompt completions
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.syncTrackingWithRevenueCat()
            }
            .store(in: &cancellables)
    }
    
    
    func requestTrackingAuthorization() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            syncTrackingWithRevenueCat()
            return
        }
        
        /// Adding a slight delay ensures the view hierarchy is fully ready before the alert presents
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("ATT Authorized: User opted in to tracking.")
                case .denied:
                    print("ATT Denied: User opted out of tracking.")
                case .notDetermined:
                    print("ATT Not Determined: The prompt hasn't been shown yet.")
                case .restricted:
                    print("ATT Restricted: Device settings prevent tracking.")
                @unknown default:
                    print("ATT Unknown status.")
                }
                
                
                /// Initialize AdMob only AFTER the user has answered the prompt
                /// This ensures AdMob respects the user's ATT decision from the start
                MobileAds.shared.start(completionHandler: nil)
                Task { @MainActor in
                    self?.trackingStatus = status
                    self?.syncTrackingWithRevenueCat()
                }
            }
        }
    }
    
    
    private func syncTrackingWithRevenueCat() {
        DispatchQueue.main.async {
            let currentStatus = ATTrackingManager.trackingAuthorizationStatus
            self.trackingStatus = currentStatus
            
            /// 2. If authorized, tell RevenueCat to automatically capture the IDFA ($idfa)
            if currentStatus == .authorized {
                Purchases.shared.attribution.collectDeviceIdentifiers()
                print("IDFA synchronized with RevenueCat: \(ASIdentifierManager.shared().advertisingIdentifier)")
            }
        }
    }
}
