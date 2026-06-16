//
//  CountryCodesCatalog.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/5/26.
//

import Foundation

enum CountryCode: String, CaseIterable {
    case SV = "SV"
    case US = "US"
    case GT = "GT"
    case NI = "NI"
    
    var iso3166Alpha3Code: String {
        switch self {
            case .SV: return "SLV"
            case .US: return "USA"
            case .GT: return "GTM"
            case .NI: return "NIC"
        }
    }
}
