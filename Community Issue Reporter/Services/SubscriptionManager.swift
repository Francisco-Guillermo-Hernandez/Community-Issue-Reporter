import Foundation
import RevenueCat
import SwiftUI
import Observation
internal import Combine

@Observable
class SubscriptionManager: NSObject {
    static let shared = SubscriptionManager()
    
    var isPro: Bool = false
    var customerInfo: CustomerInfo?
    var created: Bool = false
    
    override private init() {
        
        #if DEBUG
            Purchases.logLevel = .debug
        #else
            Purchases.logLevel = .error
        #endif
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String, !apiKey.isEmpty else {
            fatalError("REVENUECAT_API_KEY not found in Info.plist")
        }
        
        Purchases.configure(withAPIKey: apiKey)
        super.init()
        Purchases.shared.delegate = self
   
    }
    
    func performLogin() async {
        let userId = KeychainService.loadToken(key: .userId)
        guard let userId else { return }
        await performUserLogin(userId)
    }
    
    func checkEntitlement() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.customerInfo = customerInfo
                self?.isPro = customerInfo?.entitlements.all["Reportamelo Pro"]?.isActive == true
                if (self?.isPro) != nil {
                    _ = KeychainService.save(key: .planType, value: PlanType.paid.rawValue)
                } else {
                    _ = KeychainService.save(key: .planType, value: PlanType.freemium.rawValue)
                }
            }
        }
    }
    
    @MainActor
    func performUserLogin(_ userId: String) async {
        do {
          let (customerInfo, created) = try await Purchases.shared.logIn(userId)
            self.customerInfo = customerInfo
            self.isPro = customerInfo.entitlements.all["Reportamelo Pro"]?.isActive == true
            self.created = created
        } catch {
            print("RevenueCat login failed: \(error.localizedDescription)")
        }
    }

    
    func purchase(package: Package) {
        Purchases.shared.purchase(package: package) { [weak self] (transaction, customerInfo, error, userCancelled) in
            if let error = error {
                print("Purchase error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.customerInfo = customerInfo
                self?.isPro = customerInfo?.entitlements.all["Reportamelo Pro"]?.isActive == true
            }
        }
    }
    
    @MainActor
    func restorePurchases() async -> Bool {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            self.customerInfo = customerInfo
            self.isPro = customerInfo.entitlements.all["Reportamelo Pro"]?.isActive == true
            return true
        } catch {
            print("Restore error: \(error.localizedDescription)")
            return false
        }
    }
    
    @MainActor
    func handleUserLogout() async {
        do {
            let customerInfo = try await Purchases.shared.logOut()
            self.customerInfo = customerInfo
            self.isPro = false
        } catch {
            print("RevenueCat logout error: \(error.localizedDescription)")
        }
    }

}

extension SubscriptionManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        DispatchQueue.main.async {
            self.customerInfo = customerInfo
            self.isPro = customerInfo.entitlements.all["Reportamelo Pro"]?.isActive == true
        }
    }
}
