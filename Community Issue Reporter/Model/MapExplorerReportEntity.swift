//
//  MapExplorerReportEntity.swift
//  Community Issue Reporter
//

import Foundation
import SwiftData

@Model
class MapExplorerReportEntity {
    @Attribute(.unique) var id: String
    var cityId: String
    var data: Data
    var updatedAtRaw: Int64
    
    init(id: String, cityId: String, data: Data, updatedAtRaw: Int64) {
        self.id = id
        self.cityId = cityId
        self.data = data
        self.updatedAtRaw = updatedAtRaw
    }
}
