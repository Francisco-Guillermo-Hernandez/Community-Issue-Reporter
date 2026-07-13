//
//  CreateRequestValidator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import Foundation

let titleValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: "The title can't be empty",
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: "The title can't be longer than 50 characters",
        fn: { $0.count <= 50 }
    ),
    Validator(
        name: "Isn't too short",
        message: "The title can't be shorter than 5 characters",
        fn: { $0.count >= 5 }
    )
]


let descriptionValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: "The description can't be empty",
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: "The description can't be longer than 50 characters",
        fn: { $0.count <= 50 }
    ),
    Validator(
        name: "Isn't too short",
        message: "The description can't be shorter than 5 characters",
        fn: { $0.count >= 5 }
    )
]

let addressValidator: [Validator] = [
//    Validator(
//        name: "Isn't empty",
//        message: "The address can't be empty",
//        fn: { !$0.isEmpty }
//    ),
    Validator(
        name: "Isn't too long",
        message: "The address can't be longer than 200 characters",
        fn: { $0.count <= 200 }
    ),
    Validator(
        name: "Isn't too short",
        message: "The address can't be shorter than 5 characters",
        fn: { $0.count >= 5 }
    ),
//    Validator(
//        name: "Validate address",
//        message: String(localized: "The address contains invalid characters"),
//        fn: { value in
//            let addressRegex = /^[\p{L}0-9\s,.\-#]+$/
//            return value.wholeMatch(of: addressRegex) != nil
//        }
//    )
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


let userNameValidator: [Validator] = [
    Validator(
        name: "Isn't empty",
        message: "User name can't be empty",
        fn: { !$0.isEmpty }
    ),
    Validator(
        name: "Isn't too long",
        message: "User name can't be longer than 20 characters",
        fn: { $0.count <= 20 }
    ),
    Validator(
        name: "Isn't too short",
        message: "User name can't be shorter than 3 characters",
        fn: { $0.count >= 3 }
    )
]

let userNameRegex = "[a-zA-Z0-9._-]"
