import Foundation
import SwiftData

@Model
class MyReportDAOEntity {
    @Attribute(.unique) var id: String
    var page: Int
    var data: Data
    var hasNext: Bool
    
    init(id: String, page: Int, data: Data, hasNext: Bool) {
        self.id = id
        self.page = page
        self.data = data
        self.hasNext = hasNext
    }
}
