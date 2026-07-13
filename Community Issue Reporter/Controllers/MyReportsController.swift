//
//  MyReportsController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 16/6/26.
//

import SwiftUI
import Observation


@MainActor
@Observable
final class MyReportsController {
    var reports: [Report] = []
    var showDeleteAlert: Bool = false
    var elementToDelete: IndexSet = []
    var reportToDelete: Report? = nil
    var refreshID = UUID()
    var isLoading: Bool = false
    
    let model = ReportDataModel.shared
    
    func fetchReports() async {
        isLoading = true
        do {
            
            let result = try await ReportRepository.shared.listByUser(page: 1)
            guard let documents = result.documents else { return }
            self.reports = documents.map { $0.toModel() }
        } catch {
            print(error)
        }
        
        isLoading = false
    }
    
    func confirmDeletion(of id: String) {
        withAnimation {
            reports.removeAll { $0.id == id }
        }
        reportToDelete = nil
    }
    
    func delete(report id: Report? = nil) {
        Task {
            guard let id = id?.id else { return }
            
            do {
                let result = try await ReportRepository.shared.delete(id)
                if result == .deleted {
                    self.confirmDeletion(of: id)
                } else {
                    
                }
            } catch {
                
            }
        }
    }
}
