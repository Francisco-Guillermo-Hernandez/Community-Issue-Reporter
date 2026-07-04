//
//  DeviceService.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/6/26.
//

import Foundation
import SwiftUI

final class DeviceService {
    
    static let shared = DeviceService()
    
    func getDeviceId() -> String {
        
        /// Check if we already saved a device ID to the Keychain
        if let keychainDeviceID = KeychainService.loadToken(key: .deviceId) {
            return keychainDeviceID
        }
        
        /// Fallback: Get the Identifier for Vendor (IDFV)
        var newDeviceID = UIDevice.current.identifierForVendor?.uuidString
        
        /// Ultra-Fallback: If IDFV is somehow nil, generate a fresh UUID
        if newDeviceID == nil {
            newDeviceID = UUID().uuidString
        }
        
        let idToSave = newDeviceID!
        
        /// Save it to the Keychain so it survives app uninstalls
        _ = KeychainService.save(key: .deviceId, value: idToSave)
        
        return idToSave
    }
}
