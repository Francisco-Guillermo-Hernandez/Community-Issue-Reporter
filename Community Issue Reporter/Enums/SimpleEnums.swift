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
enum LoginType {
    case guest
    case user
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
    case networkError(String)
    case genericError(String)
    case notImplemented
}

// MARK: - 
enum SuccessfulResult: Equatable {
    case done
    case updated
    case deleted
    case created(String)
}
