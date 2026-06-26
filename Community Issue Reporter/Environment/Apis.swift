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
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: "https://\(urlString)") else {
            fatalError("BASE_URL not found in Info.plist")
        }
        
        return url
    }
    
    static var shareableURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SHARE_URL") as? String,
              let url = URL(string: "https://\(urlString)") else {
            fatalError("SHARE_URL not found in Info.plist")
        }
        
        return url
    }
}
