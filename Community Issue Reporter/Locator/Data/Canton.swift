//
//  Canton.swift
//  migration
//
//  Created by Francisco Hernandez on 2/7/26.
//

import Foundation
import SwiftData

@Model
final class Canton {
    @Attribute(.unique) var code: String
    var name: String?
    var cityId: String?
    
    var district: District?
    
    #Index<Canton>([\.cityId])
    
    init(code: String, name: String? = nil, cityId: String? = nil, district: District? = nil) {
        self.code = code
        self.name = name
        self.cityId = cityId
        self.district = district
    }
}
