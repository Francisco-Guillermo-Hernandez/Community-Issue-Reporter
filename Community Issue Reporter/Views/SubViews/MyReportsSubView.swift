//
//  MyReportsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/3/26.
//

import SwiftUI

struct ReportCellView: View {
    
    var report: Report
    fileprivate func genericDatePresenter(_ text: String, when: String) -> some View {
        return HStack(alignment: .center, spacing: .themeSpacing) {
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
                        genericDatePresenter("Created", when: report.createdDate)
                        genericDatePresenter("Updated", when: report.updatedDate)
                        genericDatePresenter("Reported", when: report.reportedDate)
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
                Image(systemName: "chevron.compact.right")
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct ReportDetailView: View {
    var report: Report
    var body: some View {
        Text("Hello, world!")
    }
}

struct MyReportsSubView: View {
    
    @State private var reports: [Report] = []
    @State private var showDeleteAlert: Bool = false
    @State private var elementToDelete: IndexSet = []
    @State private var reportToDelete: Report? = nil
    @State private var model: ReportDataModel = .init()
    
    var subViewName: String
    var body: some View {
        List {
            ForEach(reports, id: \.id) { report in
                ZStack {
                    NavigationLink(destination: self.report(report: report)) {
                        EmptyView().frame(width: 0, height: 0)
                    }
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    
                    ReportCellView(report: report)
                        .cellStyle()
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            HStack {
                                Button(role: .destructive) {
                                    reportToDelete = report
                                    showDeleteAlert.toggle()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.theme.destructive)
                                
                                Button {
                                    
                                } label: {
                                    Label("Modify", systemImage: "pencil")
                                }
                                .tint(.theme.secondary)
                            }
                        }
                }
                .listRowInsets(
                    EdgeInsets(
                        top: .themeSpacing * 2,
                        leading: .themeSpacing * 4,
                        bottom: .themeSpacing * 2,
                        trailing: .themeSpacing * 4
                    )
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
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
        .toolbar {
            
        }
        .task {
            guard !Task.isCancelled else { return }
            await ReportRepository.listByUser(
                page: 1,
                onComplete: { result in
                    
                    guard let reports = result.documents else { return }
                    
                    self.reports.append(contentsOf: reports)
                },
                onError: { error in
                    print(error)
                }
            )
            
        }
        
        .navigationTitle(subViewName)
    }
    

    @ViewBuilder
    private func report(report: Report) -> some View {
        ReportView(model: model, onCompletion: { _, _ in
   
        })
        .onAppear {
            model.prepareForModification(report)
        
        }
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
            await ReportRepository.delete(
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

#Preview {
    let reports = [
        Report(
            coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
            address: "PanAmerican Highway, San Salvador, San Salvador, El Salvador",
            title: "Un bache en la avenida",
            description: "Un bache esta afectando a muchas personas en la avenida",
            severityId: 1,
            statusId: 1,
            issueTypeId: 3,
            matterToSolveId: "",
            cellIndex: "",
            createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
            updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
        ),
        Report(
            coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
            address: "PanAmerican Highway, San Salvador, San Salvador, El Salvador",
            title: "Un bache en la avenida",
            description: "Un bache esta afectando a muchas personas en la avenida",
            severityId: 1,
            statusId: 1,
            issueTypeId: 3,
            matterToSolveId: "",
            cellIndex: "",
            createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
            updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
        ),
        Report(
            coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
            address: "PanAmerican Highway, San Salvador, San Salvador, El Salvador",
            title: "Un bache en la avenida",
            description: "Un bache esta afectando a muchas personas en la avenida",
            severityId: 1,
            statusId: 1,
            issueTypeId: 3,
            matterToSolveId: "",
            cellIndex: "",
            createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
            updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
        ),
        Report(
            coordinate: Coordinate(lat: 13.693175616298355, lng:-89.21848208712787 ),
            address: "PanAmerican Highway, San Salvador, San Salvador, El Salvador",
            title: "Un bache en la avenida",
            description: "Un bache esta afectando a muchas personas en la avenida",
            severityId: 1,
            statusId: 1,
            issueTypeId: 3,
            matterToSolveId: "",
            cellIndex: "",
            createdAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
            updatedAt: parsePostgresDate("2026-04-19T22:47:41.213141-06:00"),
        )
    ]
    NavigationStack {
        MyReportsSubView(subViewName: "My Reports")
    }
}

