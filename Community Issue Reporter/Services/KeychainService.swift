//
//  KeychainService.swift
//  Hello Google Auth
//
//  Created by Francisco Hernandez on 5/4/26.
//

import Foundation
import Security

class KeychainService {
    static func save(key: TokenType, value: String) -> Bool {
        
        print("tokken: \(value)")
        print("key: \(key.rawValue)")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleID,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8)!,
        ]
        
        SecItemDelete(query as CFDictionary)
        let result = SecItemAdd(query as CFDictionary, nil)
        return result == noErr
    }
    
    static func loadToken(key: TokenType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleID, 
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            if let retrievedData = dataTypeRef as? Data {
                return String(data: retrievedData, encoding: .utf8)
            }
        }
        return nil
    }
    
    static func deleteToken(key: TokenType) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleID,
            kSecAttrAccount as String: key.rawValue,
        ]
        
        let result = SecItemDelete(query as CFDictionary)
        return result == noErr
    }
    
    static func getToken(_ t: TokenType) -> String {
        return loadToken(key: t) ?? ""
    }
}

enum TokenType: String {
    case mutation = "mutationActionsToken"
    case query = "queryActionsToken"
}

extension KeychainService {
    static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? "dev.FranciscoHernandez.default"
    }
}
