//
//  SimpleEnums.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 3/6/26.
//

import Foundation

// MARK: - 
enum ViewOptions: String {
    case list
    case listAndModify
}

// MARK: - Login options presented in the LoginView page

enum AuthMethod: String, Hashable {
    case Apple
    case Google
}

enum LoginType: Sendable, Hashable {
    case guest
    case user(authMethod: AuthMethod)
}

enum TextBasedAvatarOptions: String {
    case monogram
    case initials
}

enum MonogramMode: String {
    case preview
    case send
}

// MARK: - Options to create an avatar
enum AvatarCreatedFrom: String, Codable {
    case optionsSelector
    case avatar
    case camera
    case photo
    case initials
    case monogram
    case GoogleAuth
    case Memoji
}

// MARK: - type of user can login into the app
enum UserType: String, Codable {
    case guest
    case citizen
    case government
    
    var description: String {
        switch self {
            case .citizen:
                return "Citizen"
            case .government:
                return "Government"
            case .guest:
                return "Guest"
        }
    }
}

// MARK: - personalized error handler
enum CommonIntercommunicationErrors: Error {
    case delayed
    case timedOut
    case removed
    case notFound
    case invalidPetition(String)
    case serverError(String)
    case notAuthorized
    case forbidden(GenericResponse)
    case networkError(String)
    case genericError(String)
    case notImplemented
    case unProcessable
}

// MARK: - 
enum SuccessfulResult: Equatable {
    case done
    case updated
    case deleted
    case created
}

enum VotingType: String, Equatable, CaseIterable, Codable {
    case report
    case petition
    
    var description: String {
        switch self {
            case .petition:
                return String(localized: "Petition")
            case .report:
                return String(localized: "Report")
        }
    }
}
