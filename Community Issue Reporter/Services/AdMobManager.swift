import Foundation
import GoogleMobileAds
@_spi(Experimental) import RevenueCatAdMob
import UIKit
internal import Combine

class AdMobManager: NSObject, ObservableObject {
    static let shared = AdMobManager()
    
    private var rewardedAd: RewardedAd?
    
    override private init() {
        super.init()
    }
    
    @discardableResult
    func loadRewardedAd(adUnitID: String) async -> Bool {
        let request = Request()
        
        do {
            self.rewardedAd = try await RewardedAd.loadAndTrack(withAdUnitID: adUnitID, request: request)
            return true
        } catch {
            print(error)
            print("Failed to load rewarded ad: \(error.localizedDescription)")
            self.rewardedAd = nil
            return false
        }
    }
    
    @MainActor
    func showRewardedAd(onReward: @escaping () -> Void) {
        guard let rewardedAd = self.rewardedAd else {
            print("Ad wasn't ready")
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("Could not find root view controller")
            return
        }
        
        var topViewController = rootViewController
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        rewardedAd.present(from: topViewController) {
            let reward = rewardedAd.adReward
            print("Reward received with currency: \(reward.type), amount \(reward.amount).")
            onReward()
        }
    }
}
