import Foundation
import RevenueCat
import SwiftUI

internal import Combine

class SubscriptionManager: NSObject, ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var isPro: Bool = false
    @Published var customerInfo: CustomerInfo?
    
    override private init() {
        super.init()
        Purchases.shared.delegate = self
        checkEntitlement()
    }
    
    func checkEntitlement() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.customerInfo = customerInfo
                self?.isPro = customerInfo?.entitlements.all["Reportamelo Pro"]?.isActive == true
            }
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
    
    func restorePurchases() {
        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
            if let error = error {
                print("Restore error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.customerInfo = customerInfo
                self?.isPro = customerInfo?.entitlements.all["Reportamelo Pro"]?.isActive == true
            }
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
