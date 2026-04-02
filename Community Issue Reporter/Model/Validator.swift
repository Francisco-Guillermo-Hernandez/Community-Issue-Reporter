//
//  Validator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import Foundation

struct Validator {
    var name: String
    var message: String
    var fn: (_ input: String) -> Bool
}
