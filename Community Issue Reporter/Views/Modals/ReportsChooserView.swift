//
//  ReportsChooserView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/3/26.
//

import SwiftUI

struct ReportsChooserView: View {
    var reports: [Report]
    @Binding var selectedReports: [String]
    @State private var searchText = ""
    
    var filteredReports: [Report] {
        if searchText.isEmpty {
            return reports
        } else {
            return reports.filter {
                $0.description.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredReports, id: \.id) { report in
                MultipleSelectionRow(report: report, isSelected: self.selectedReports.contains(getId(from: report))) {
                    if let index = self.selectedReports.firstIndex(of: report.id!) {
                        self.selectedReports.remove(at: index)
                    } else {
                        self.selectedReports.append(getId(from: report))
                    }
                }
            }
//            .scrollContentBackground(.hidden)
            .interactiveDismissDisabled()
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search a report")
            .navigationTitle("Choose one or multiple reports")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        
                    } label: {
                        Label("Options", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
        }
    }
    
   private func getId(from report: Report) -> String {
       guard let id = report.id else { return "" }
       return id
    }
}

struct MultipleSelectionRow: View {
    var report: Report
    var isSelected: Bool = false
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.description)
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundStyle(.primary)
                    
                    
                    HStack(spacing: 4) {
                        Text("Address: ")
                            .font(.caption)
                        Text(report.address)
                            .font(.caption)
                    }
                         
                    if report.reportedAt != nil {
                        HStack(spacing: 4) {
                            Text("Reported at: ")
                                .font(.caption)
                            Text(report.reportedAt.map(formatDate) ?? "Unknown date")
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .foregroundStyle(Color.blue)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
       
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
}

#Preview {

    @Previewable
    @State var reports: [Report] = []
    
    @Previewable
    @State var selectedReports: [String] = []

    ReportsChooserView(reports: reports, selectedReports: $selectedReports)
}
