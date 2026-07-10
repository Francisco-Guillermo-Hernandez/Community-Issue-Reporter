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
                    .fixedSize()
                
                Text(when)
                    .fixedSize()
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
                    
                    /// detail of the dates
                    HStack(spacing: .themeSpacing * 4) {
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
                    .padding(.top, .themeSpacing)
                    .padding(.bottom, .themeSpacing)
                    
                    /// Badges to identify the report
                    HStack(spacing: .themeSpacing * 4) {
                        CustomBadgeView(
                            badge: .init(
                                color: report.severity.color,
                                title: report.severity.title,
                                icon: report.severity.iconName
                            )
                        )
                        
                        CustomBadgeView(
                            badge: .init(
                                color: report.status.color,
                                title: report.status.title,
                                icon: report.status.iconName
                            )
                        )
                        
                        CustomBadgeView(
                            badge: .init(
                                color: report.issueType.color,
                                title: report.issueType.title,
                                icon: report.issueType.iconName
                            )
                        )
                        
                       
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
    @State private var controller = MyReportsController()
    @Binding var path: [InsightsNavigation]
    var subViewName: String
    var mode: ViewOptions = .list
    var body: some View {
        ZStack {
            if controller.isLoading {
                /// Show in the middle of the screen
                LoadingView()
            }

            if controller.reports.isEmpty && !controller.isLoading {
                /// Empty state
                ContentUnavailableView {
                    Label(
                        "No reports yet.",
                        systemImage: "exclamationmark.bubble"
                    )
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.theme.foreground.opacity(0.7),
                        Color.theme.primary,
                        Color.theme.foreground.opacity(0.7)
                    )
                } description: {
                    Text("Please sent us reports.")
                }
                .containerRelativeFrame(.vertical)
            } else {
                List {
                    ForEach(controller.reports, id: \.id) { report in
                        ReportCellView(report: report)
                            .cellStyle()
                    }
                }
                .listStyle(.plain)
            }

        }
//        .ignoresSafeArea(edges: .all)
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .alert("Delete report", isPresented: $controller.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                controller.delete(report: controller.reportToDelete)
            }
            
            Button("Cancel", role: .cancel) {
                controller.reportToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete ? This action cannot be undone.")
        }
        .task(id: controller.refreshID) {
            guard !Task.isCancelled else { return }
            await controller.fetchReports()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(subViewName)
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
