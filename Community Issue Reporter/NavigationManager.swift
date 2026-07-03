//
//  NavigationManager.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/6/26.
//

import SwiftUI
internal import Combine

class ReportDetailsHandler: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var report: MapExplorerReport = .init(id: "", lat: 0, lng: 0, address: "", title: "", description: "", severityId: 1, statusId: 1, issueTypeId: 1, matterToSolveId: 1, reportedAtRaw: 0, cellIndex: "", createdAtRaw: 0, updatedAtRaw: 0, reportedBy: "", cityId: "", petitionId: "", shareUrl: "",
                                                     attachments: []
    )
    @Published var isLoading: Bool = false
    
    
    func showDetails(of report: MapExplorerReport) {
//        self.isPresented = true
        self.report = report
    }
}
