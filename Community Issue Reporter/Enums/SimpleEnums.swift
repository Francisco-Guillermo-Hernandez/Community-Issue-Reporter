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

// MARK: -
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

// MARK: - 
enum CurrentView: String {
    case optionsSelector
    case avatar
    case camera
    case photo
    case initials
    case monogram
    case GoogleAuth
}

enum UserType: String, Codable {
    case guest
    case citizen
    case government
}
