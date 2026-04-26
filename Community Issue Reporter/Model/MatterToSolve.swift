//
//  MatterToSolve.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation

struct MatterToSolve: Identifiable {
    var id: Int
    var title: String
    var icon: String?
    var description: String
    var issueType: IssueTypes
    var severity: Severity
    var image: String?
    var suggestions: [String]?
    
    init(id: Int, title: String, icon: String? = nil, description: String, issueType: IssueTypes, severity: Severity, image: String? = nil, suggestions: [String]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.description = description
        self.issueType = issueType
        self.severity = severity
        self.image = image
        self.suggestions = suggestions
    }
}
