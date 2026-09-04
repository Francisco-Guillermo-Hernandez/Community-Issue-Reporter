//
//  MyReportsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct HeaderText: View {
    init(_ text: String) {
        self.text = text
    }
    var text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.bold)
            .fixedSize()
    }
}

struct BottomText: View {
    var text: String
    var multiline: Bool
    
    init(_ text: String, multiline: Bool = false) {
        self.text = text
        self.multiline = multiline
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: !multiline, vertical: true)
    }
}


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
                
                HeaderText(text)
                
                BottomText(when)
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
            ZStack(alignment: .trailing) {
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
                        .accessibilityElement(children: .combine)
                        
                        GenericDatePresenterView(
                            text: String(localized: "Updated", comment: "Updated description text at the report section"),
                            when: report.updatedDate
                        )
                        .accessibilityElement(children: .combine)
                        
                        GenericDatePresenterView(
                            text: String(localized: "Assigned", comment: "Reported description text at the report section"),
                            when: report.reportedDate
                        )
                        .accessibilityElement(children: .combine)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, .themeSpacing)
                    .padding(.bottom, .themeSpacing)
                    
                    Group {
                        if let observations = report.observations, !observations.isEmpty {
                            VStack {
                                HeaderText(String(localized: "Observations"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                BottomText(observations, multiline: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                            }
                            .padding(.leading)
                            .padding(.top, .themeSpacing)
                            .padding(.bottom, .themeSpacing)
                        }
                    }
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack {
                                HeaderText(String(localized: "Issue type"))
                                    .frame(maxWidth: .infinity)
                                
                                CustomBadgeView(
                                    badge: .init(
                                        color: report.issueType.color,
                                        title: report.issueType.title,
                                        icon: report.issueType.iconName
                                    )
                                )
                                
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Issue type: \(report.issueType.title)")
                            
                            VStack {
                                HeaderText(String(localized: "Severity"))
                                    .frame(maxWidth: .infinity)
                                
                                CustomBadgeView(
                                    badge: .init(
                                        color: report.severity.color,
                                        title: report.severity.title,
                                        icon: report.severity.iconName
                                    )
                                )
                                
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Severity: \(report.severity.title)")
                            
                            VStack {
                                HeaderText(String(localized: "Status"))
                                    .frame(maxWidth: .infinity)
                                
                                CustomBadgeView(
                                    badge: .init(
                                        color: report.status.color,
                                        title: report.status.title,
                                        icon: report.status.iconName
                                    )
                                )
                                
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Status: \(report.status.title)")
                        }
                    }
                    .padding(.top, .themeSpacing)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if enableChevron {
                    Image(systemName: "chevron.compact.right")
                        .foregroundColor(.secondary)
                        .opacity(0.85)
                }
            }
        }
    }
}

// MARK: - sub view
struct MyReportsSubView: View {
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.colorScheme) private var colorScheme
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
                        Group {
                            if mode == .listAndModify {
                                let disableNavigation: Bool = [.reported, .rectification].contains(report.status)
                                
                                Group {
                                    if !disableNavigation {
                                        ReportCellView(report: report, enableChevron: false)
                                            .cellStyle()
                                            .padding(.themeSpacing)
                                    } else {
                                        NavigationLink(destination: showWizard(report)) {
                                            ReportCellView(report: report, enableChevron: true)
                                                .cellStyle()
                                                .padding(.themeSpacing)
                                        }
                                    }
                                }
                                .listRowInsets(themeCellEdgeInsets)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        controller.reportToDelete = report
                                        controller.showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .contentShape(
                                       .contextMenuPreview,
                                       RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                                )
                                .contextMenu {
                                    reportContextMenu(report)
                                }
                            } else {
                                ReportCellView(report: report)
                                    .cellStyle()
                            }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Report")
                        .task {
                            if report.id == controller.reports.last?.id {
                                Task {
                                    await controller.fetchReports(loadMore: true)
                                }
                            }
                        }
                    }
                    
                    if controller.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listStyle(.plain)
                .refreshable {
                    await controller.fetchReports()
                }
            }
            
            if !networkMonitor.isConnected {
                NoNetwork {
                    await controller.fetchReports()
                }
            }

        }
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
        .background {
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.theme.secondary.mix(with: colorScheme == .dark ? .black : .white, by: 0.4).opacity(0.67),
                            Color.theme.background
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: geo.size.width * 0.54
                    )
                    
                }
            }
            .ignoresSafeArea()
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                if controller.isLoading {
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .controlSize(.regular)
//                }
//            }
//        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(subViewName)
        
    }
    
    @ViewBuilder
    private func reportContextMenu(_ report: Report) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            controller.openInMaps(report.coordinate)
        } label: {
            Label("Open in Maps", systemImage: "map")
        }
        .accessibilityIdentifier("OpenInMapsButton")
        
        Button {
            UIPasteboard.general.string = report.id
        } label: {
            Label("Copy ID", systemImage: "document.on.document")
        }
        .accessibilityIdentifier("CopyIDButton")
        
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            shareFromClosure(item: buildShareURL(for: report.shareUrl!))
        } label: {
            Label("Share Report", systemImage: "square.and.arrow.up")
        }
        .accessibilityIdentifier("ShareReportURLButton")
        
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if let reportId = report.id {
                ProfileRouter.shared.goTo(.timeline(reportId: reportId))
            }
        } label: {
            Label("Timeline", systemImage: "calendar.badge.clock")
        }
        .accessibilityIdentifier("OpenTimelineButton")
        
        Divider()
        
        Button(role: .destructive) {
            controller.reportToDelete = report
            controller.showDeleteAlert = true
        } label: {
            Label("Delete", systemImage: "document.on.trash")
        }
        .accessibilityIdentifier("DeleteReportButton")
        .accessibilityLabel("Delete")
    }
    
    @ViewBuilder
    private func showWizard(_ report: Report) -> some View {
        ReportWizardContainer(
            model: controller.model,
            onCompletion: { _, _ in },
            reportToModify: report
        )
    }
}

// MARK: - Preview
#Preview {
    @Previewable
    @State var path: [InsightsNavigation] = []
    return NavigationStack {
        MyReportsSubView(path: $path, subViewName: "My Reports")
            .environment(NetworkMonitor())
    }
}
