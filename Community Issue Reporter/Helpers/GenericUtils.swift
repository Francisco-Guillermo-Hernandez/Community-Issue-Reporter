//
//  GenericUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import Foundation

func getBundle() -> String {
    return Bundle.main.bundleIdentifier ?? "dev.FranciscoHernandez.default"
}
