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
    
    static func getArray(key: TokenType) -> [String] {
        guard let jsonString = loadToken(key: key),
              let data = jsonString.data(using: .utf8) else {
            return []
        }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            return []
        }
    }
    
    static func addToArray(key: TokenType, element: String) -> Bool {
        var array = getArray(key: key)
        guard !array.contains(element) else { return true }
        
        array.append(element)
        
        do {
            let data = try JSONEncoder().encode(array)
            guard let jsonString = String(data: data, encoding: .utf8) else { return false }
            return save(key: key, value: jsonString)
        } catch {
            return false
        }
    }
    
    static func removeFromArray(key: TokenType, element: String) -> Bool {
        var array = getArray(key: key)
        guard array.contains(element) else { return true }
        
        array.removeAll { $0 == element }
        
        do {
            let data = try JSONEncoder().encode(array)
            guard let jsonString = String(data: data, encoding: .utf8) else { return false }
            return save(key: key, value: jsonString)
        } catch {
            return false
        }
    }
    
    static func getToken(_ t: TokenType) -> String {
        return loadToken(key: t) ?? ""
    }
}

enum TokenType: String {
    case mutation = "mutationActionsToken"
    case query = "queryActionsToken"
    case landingPageComplete = "landingPageComplete"
    case sessionStateVerification = "sessionStateVerification"
    case deviceId = "deviceId"
    case userType = "userType"
    case userId = "userId"
    case profileId = "profileId"
    case email = "email"
    case name = "name"
    case authMethod = "authMethod"
    case authenticationMethod = "authenticationMethod"
    case blockedUsers = "blockedUsers"
}

extension KeychainService {
    static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? "dev.FranciscoHernandez.default"
    }
}
