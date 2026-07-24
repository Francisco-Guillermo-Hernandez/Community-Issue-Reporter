//
//  CreateRequestValidator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import Foundation

/// 
let titleMinCharacters: Int = 5
let titleMaxCharacters: Int = 30
let titleValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: String(localized: "The title can't be empty"),
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: String(localized: "The title can't be longer than \(titleMaxCharacters) characters"),
        fn: { $0.count <= titleMaxCharacters }
    ),
    Validator(
        name: "Isn't too short",
        message: String(localized: "The title can't be shorter than \(titleMinCharacters) characters"),
        fn: { $0.count >= titleMinCharacters }
    )
]

///
let descriptionMinCharacters: Int = 5
let descriptionMaxCharacters: Int = 90
let descriptionValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: String(localized: "The description can't be empty"),
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: String(localized: "The description can't be longer than \(descriptionMaxCharacters) characters"),
        fn: { $0.count <= descriptionMaxCharacters }
    ),
    Validator(
        name: "Isn't too short",
        message: String(localized: "The description can't be shorter than \(descriptionMinCharacters) characters"),
        fn: { $0.count >= descriptionMinCharacters }
    )
]

///
let addressMinCharacters: Int = 5
let addressMaxCharacters: Int = 200
let addressValidator: [Validator] = [
    Validator(
        name: "Isn't too long",
        message: String(localized: "The address can't be longer than \(addressMaxCharacters) characters"),
        fn: { $0.count <= addressMaxCharacters }
    ),
    Validator(
        name: "Isn't too short",
        message: String(localized: "The address can't be shorter than \(addressMinCharacters) characters"),
        fn: { $0.count >= addressMinCharacters }
    ),
]

let addressRegex = "[\\p{L}0-9\\s,.\\-#]"

var emailValidator: [Validator] = [
    Validator(
        name: "Validate email",
        message: String(localized: "Your email is invalid"),
        fn: { value in
            let emailRegex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$/
            return value.wholeMatch(of: emailRegex) != nil
        }
        
    )
]

/// Validator to evaluate userName in ...
let userNameMinCharacters: Int = 3
let userNameMaxCharacters: Int = 20
let userNameValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: String(localized: "User name can't be empty"),
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: String(localized: "User name can't be longer than \(userNameMaxCharacters) characters"),
        fn: { $0.count <= userNameMaxCharacters }
    ),
    Validator(
        name: "Isn't too short",
        message: String(localized: "User name can't be shorter than \(userNameMinCharacters) characters"),
        fn: { $0.count >= userNameMinCharacters }
    )
]

let userNameRegex = "[a-zA-Z0-9._-]"
