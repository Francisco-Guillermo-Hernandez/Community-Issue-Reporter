//
//  MatterToSolve.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import Foundation

struct MatterToSolve: Identifiable {
    var id: String
    var title: String
    var icon: String?
    var description: String
    var issueType: IssueTypes
    var severity: Severity
}
