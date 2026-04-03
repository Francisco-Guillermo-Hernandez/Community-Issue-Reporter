//
//  GenericValidator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import Foundation

func isAValidText(_ text: String) -> Bool {
    let pattern = "^[a-zA-Z0-9\\. -#]+$"
    return text.range(of: pattern, options: .regularExpression) != nil
}
