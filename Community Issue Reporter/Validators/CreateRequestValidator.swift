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
