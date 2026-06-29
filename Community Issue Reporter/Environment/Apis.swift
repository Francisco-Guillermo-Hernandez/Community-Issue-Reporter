//
//  Production.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/3/26.
//

import Foundation

let userAgent = "Reportamelo/1.0"

enum Endpoints {
    static var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return URL(string: "https://localhost")! // Fallback domain for canvas
            }
            fatalError("BASE_URL not found in Info.plist")
        }
        
        guard let url = URL(string: "https://\(urlString)") else {
            fatalError("Invalid BASE_URL formatting")
        }
        
        return url
    }
    
    static var apiV1: URL {
        Self.baseURL.appending(component: "api").appending(component: "v1")
    }
    
    static var shareableURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SHARE_URL") as? String else {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return URL(string: "https://localhost")!
            }
            fatalError("SHARE_URL not found in Info.plist")
        }
        
        guard let url = URL(string: "https://\(urlString)") else {
            fatalError("Invalid SHARE_URL formatting")
        }
        
        return url
    }
 
}
