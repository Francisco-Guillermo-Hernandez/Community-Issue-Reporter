//
//  Responses.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/3/26.
//

import Foundation


struct GenericResponse: Identifiable, Codable {
   var id: String
}

struct LoginWithOAuthProviderResponse: Decodable {
    var code: String
    var authToken: String
    var authProvider: String
}
