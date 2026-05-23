//
//  MyReportsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

// MARK: - GenericDatePresenterView
struct GenericDatePresenterView: View {
    var text: String
    var when: String
    
    var body: some View {
        HStack(alignment: .center, spacing: .themeSpacing) {
            VStack {
                Image(systemName: "calendar")
                    .foregroundStyle(Color.secondary)
            }
            VStack(alignment: .leading ) {
                
                Text(text)
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text(when)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

// MARK: - CellView
struct ReportCellView: View {
    
    var report: Report
    var enableChevron: Bool = false
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(report.title)
                        .font(.title2)
                        .fontWidth(.condensed)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(report.description)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, .themeSpacing)
                    // detail of the dates
                    HStack {
                        GenericDatePresenterView(
                            text: String(localized: "Created", comment: "Created description text at the report section"),
                            when: report.createdDate
                        )
                        
                        GenericDatePresenterView(
                            text: String(localized: "Updated", comment: "Updated description text at the report section"),
                            when: report.updatedDate
                        )
                        
                        GenericDatePresenterView(
                            text: String(localized: "Reported", comment: "Reported description text at the report section"),
                            when: report.reportedDate
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, .themeSpacing)
                    .padding(.bottom, .themeSpacing)
                    
                    HStack(spacing: .themeSpacing * 2) {
                        CustomBadgeView(badge: .init(color: report.severity.color, title: report.severity.title, icon: report.severity.iconName))
                            .opacity(0.77)
                        CustomBadgeView(badge: .init(color: report.status.color, title: report.status.title, icon: report.status.iconName))
                            .opacity(0.77)
                        
                        CustomBadgeView(badge: .init(color: report.issueType.color, title: report.issueType.title, icon: report.issueType.iconName)).opacity(0.77)
                        
                    }
                    
                }
                
                if enableChevron {
                    Image(systemName: "chevron.compact.right")
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

// MARK: - sub view
struct MyReportsSubView: View {
    
    @State private var reports: [Report] = []
    @State private var showDeleteAlert: Bool = false
    @State private var elementToDelete: IndexSet = []
    @State private var reportToDelete: Report? = nil
    @State private var model: ReportDataModel = ReportDataModel.shared
    @State private var refreshID = UUID()
    
    @Binding var path: [InsightsNavigation]
    var subViewName: String
    var body: some View {
        List {
            ForEach(reports, id: \.id) { report in
                ReportCellView(report: report)
                    .cellStyle()
            }
        }
        .listStyle(.plain)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .alert("Delete report", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                delete(report: reportToDelete)
            }
            Button("Cancel", role: .cancel) {
                self.reportToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete ? This action cannot be undone.")
        }
        .task(id: refreshID) {
            await fetchReports()
        }
        .onAppear {
            refreshID = UUID()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(subViewName)
    }
    
    private func fetchReports() async {
        await ReportRepository.shared.listByUser(
            page: 1,
            onComplete: { result in
                guard let reports = result.documents else { return }
                self.reports = reports
            },
            onError: { error in
                print(error)
            }
        )
    }

    
    
    private func confirmDeletion(of id: String) {
        withAnimation {
            reports.removeAll { $0.id == id }
        }
        reportToDelete = nil
    }
    
    private func delete(report id: Report? = nil) {
        Task {
            guard let id = id?.id else { return }
            await ReportRepository.shared.delete(
                id,
                onComplete: { result in
                    print(result)
                    confirmDeletion(of: id)
                },
                onError: { error in
                    print(error)
                }
            )
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable
    @State var path: [InsightsNavigation] = []
    return NavigationStack {
        MyReportsSubView(path: $path, subViewName: "My Reports")
    }
}

