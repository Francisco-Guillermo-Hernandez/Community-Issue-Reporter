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
        List(filteredReports, id: \.id) { report in
            MultipleSelectionRow(of: report, isSelected: isSelected(report)) {
                if let index = self.selectedReports.firstIndex(of: report.id!) {
                    self.selectedReports.remove(at: index)
                } else {
                    self.selectedReports.append(getId(from: report))
                }
            }
            .cellStyle()
        }
        .listStyle(.plain)
        .padding(.horizontal, 0)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .interactiveDismissDisabled()
        .searchable(
            text: $searchText,
            placement: .toolbar, // .navigationBarDrawer,
            prompt: String(localized: "Search a report")
        )
        .navigationTitle("Choose one or multiple reports")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button {
//                    
//                } label: {
//                    Label("Options", systemImage: "line.3.horizontal.decrease")
//                }
//            }
//        }
    }
    
   private func getId(from report: Report) -> String {
       guard let id = report.id else { return "" }
       return id
    }
    
    private func isSelected(_ report: Report) -> Bool {
        return self.selectedReports.contains(getId(from: report))
    }
}

struct MultipleSelectionRow: View {
    var report: Report
    var isSelected: Bool = false
    var action: () -> Void
    
    init(of report: Report, isSelected: Bool, action: @escaping () -> Void) {
        self.report = report
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(report.description)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    
                    HStack(spacing: 4) {
                        
                        Text(report.address)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // The check mark must be at the right always
                VStack {
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .foregroundStyle(isSelected ? Color.blue : .clear)
                }
                .frame(alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
    @State var reports: [Report] = [
        Report(

                   coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
                   address: "PanAmerican Highway, San Salvador, San Salvador, El Salvador",
                   title: "Un bache en la avenida",
                   description: "Un bache esta afectando a muchas personas en la avenida",
                   severityId: 1,
                   statusId: 1,
                   issueTypeId: 3,
                   matterToSolveId: 1,
                   cellIndex: "",
                   createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
                   updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
               ),
        Report(
           
                   coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
                   address: "PanAmerican ",
                   title: "Un bache en la avenida",
                   description: "Un ",
                   severityId: 1,
                   statusId: 1,
                   issueTypeId: 3,
                   matterToSolveId: 1,
                   cellIndex: "",
                   createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
                   updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
               )
        
    ]
    
    @Previewable
    @State var selectedReports: [String] = []

    ReportsChooserView(reports: reports, selectedReports: $selectedReports)
}
