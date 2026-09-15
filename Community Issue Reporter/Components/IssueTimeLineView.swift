//
//  IssueTimeLineView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PDFKit

enum TimeLinePresentationMode: String {
    case sheet
    case navigation
}

struct TimelineNode<Content: View>: View {
    let status: IssueStatus
    let isLast: Bool
    let content: Content

    init(status: IssueStatus, isLast: Bool = false, @ViewBuilder content: () -> Content) {
        self.status = status
        self.isLast = isLast
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 0) {
          
                ZStack {
                    Circle()
                        .fill(Color.theme.primary.opacity(0.88))
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                }
                .glassEffect(in: .circle)
                
                // The "Rail" line
                if !isLast {
                    Rectangle()
                        .fill(Color.theme.primary.opacity(0.47))
                        .frame(width: 4)
                        .glassEffect(in: .rect)
                }
            }
            .frame(width: 24)

            VStack(alignment: .leading, spacing: 8) {
                content
                Spacer().frame(height: 20)
            }
        }
    }
}

// MARK: - Multiline
struct IssueTimelineView: View {
    var reportId: String
    var mode: TimeLinePresentationMode = .sheet
    
    @State private var isLoading: Bool = false
    @State private var resolution: Resolution?
    @State private var mapExplorerController = MapExplorerController.shared
    
    init(reportId: String, mode: TimeLinePresentationMode = .sheet) {
        self.reportId = reportId
        self.mode = mode
    }
    
    var body: some View {
        
        ZStack {
            
            if isLoading {
                LoadingView()
            }
            
            ///
            if resolution == nil && !isLoading {
                /// Empty state
                ContentUnavailableView {
                    Label(
                        "No report history yet.",
                        systemImage: "calendar.badge.clock"
                    )
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.theme.foreground.opacity(0.7),
                        Color.theme.primary,
                        Color.theme.foreground.opacity(0.7)
                    )
                } description: {
                    Text("Please wait to be assigned to a institution.")
                }
                .containerRelativeFrame(.vertical)
            }
            
            if let resolution {
                ScrollView {
                   
                    VStack(alignment: .leading, spacing: 0) {
                        /// 1. Reported
                        TimelineNode(status: .reported) {
                            MilestoneHeader(title: String(localized: "Reported"), date: resolution.history.reported?.date)
                            Text("By a citizen")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            
//                            Text("By \(resolution.history.reported?.by ?? "Unknown")")
//                                .font(.subheadline)
//                                .foregroundStyle(.secondary)
                            
                            
                        }
                        
                        /// 2. Confirmed
                        if let confirmed = resolution.history.confirmed {
                            TimelineNode(status: .confirmed) {
                                MilestoneHeader(title: String(localized: "Confirmed"), date: confirmed.date ?? confirmed.computedConfirmationDate)
                                Text("Report confirmed by \(confirmed.by ?? "-")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        /// 3. In Progress (Expanded Sub-tasks)
                        if let inProgress = resolution.history.inProgress {
                            TimelineNode(status: .inProgress) {
                                VStack(alignment: .leading, spacing: .themeSpacing * 3) {
                                    MilestoneHeader(title: String(localized: "In Progress"), date: nil)
                                    Text(inProgress.assignedInstitution)
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                    
                                    // Sub-steps (Updates)
                                    VStack(alignment: .leading, spacing: .themeSpacing * 3) {
                                        ForEach(inProgress.updates) { update in
                                            HStack(alignment: .top) {
                                                Circle().fill(.orange).frame(width: 6, height: 6).padding(.top, 6)
                                                VStack(alignment: .leading) {
                                                    Text(update.comments).font(.footnote)
                                                    Text(update.date).font(.caption2).foregroundStyle(.secondary)
                                                    
                                                    if !update.attachments.isEmpty {
                                                        NavigationLink(destination: AttachmentDetailView(attachments: update.attachments)) {
                                                            Label("\(update.attachments.count) Attachments", systemImage: "paperclip")
                                                                .font(.caption)
                                                                .padding(6)
                                                                .background(Color.orange.opacity(0.1))
                                                                .cornerRadius(4)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                        
                        /// 4. Fixed
                        if let fixed = resolution.history.fixed {
                            TimelineNode(status: .fixed, isLast: true) {
                                VStack(alignment: .leading) {
                                    MilestoneHeader(title: String(localized: "Fixed"), date: fixed.date)
                                    Text(fixed.comments ?? String(localized: "Repair finalized"))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    if let attachments = fixed.attachments {
                                        
                                        
                                        NavigationLink(destination: AttachmentDetailView(attachments: attachments)) {
                                            HStack {
                                                Image(systemName: "checkmark.seal.fill")
                                                Text(String(localized: "View Final Evidence"))
                                                
                                            }
                                            .font(.system(size: 14, weight: .bold))
                                            .kerning(0.3)
                                            .padding()
                                            .background(Color.theme.secondary)
                                            .foregroundColor(.white)
                                            .contentShape(Capsule())
                                            .clipShape(Capsule())
                                            .overlay {
                                                Capsule()
                                                    .stroke(Color.theme.secondary.mix(with: .black, by: 0.01), lineWidth: 1)
                                            }
                                            .glassEffect(in: .capsule)
                                        }
                                        .padding(.top, 8)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
            }
            
        }
        .background( mode == .sheet ? Color.clear : Color.theme.background)
        .task {
            do {
                self.isLoading = true
                self.resolution = try await ReportRepository.shared.fetchResolutionByReport(reportId)
            } catch {
                print("Error fetching resolution: \(error)")
            }
            
            self.isLoading = false
        }
        .toolbar {
            if mode == .sheet {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .close) {
                        mapExplorerController.expandedItem = nil
                    }
                }
            }
        }
        .toolbarTitleDisplayMode(.large)
        .navigationTitle("Report follow up")
        .navigationSubtitle(subtitle)
        
        
    }
    
    var subtitle: String {
        if let resolution = resolution {
            return String(format: "ID: %@", resolution.id)
        } else {
            return String(localized: "No ID yet")
        }
    }
}

// MARK: - Supporting Views
struct MilestoneHeader: View {
    let title: String
    let date: String?
    
    var body: some View {
        HStack {
            Text(title).font(.headline).bold()
            Spacer()
            if let date = date {
                Text(date).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

struct PDFViewer: View {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    @State private var pdfView = PDFView()
    var body: some View {
        VStack {
            PDFKitView(pdfView: pdfView, url: url)
                .ignoresSafeArea(edges: .all)
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                
                Button {
                    pdfView.autoScales = true
                } label: {
                    Image(systemName: "arrow.down.forward.and.arrow.up.backward.rectangle")
                }
                
                Button {
                    if pdfView.canZoomOut { pdfView.zoomOut(nil) }
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                }
                .disabled(!pdfView.canZoomOut)
                .accessibility(identifier: "zoom out")
                
                Button {
                    if pdfView.canZoomIn { pdfView.zoomIn(nil) }
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                }
            }
        }
        .navigationTitle("Final evidence")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.theme.background)
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfView: PDFView
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.maxScaleFactor = 4.0 /// Sets maximum allowable zoom level
        pdfView.minScaleFactor = 0.5 /// Sets minimum allowable zoom level
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct AttachmentDetailView: View {
    let attachments: [Attachment]
    
    var body: some View {
        List(attachments) { item in
            if item.type == .document, let url = URL(string: item.url) {
                NavigationLink(destination: PDFViewer(url).navigationTitle("Document Preview").navigationBarTitleDisplayMode(.inline)) {
                    attachmentRow(for: item)
                }
            } else {
                attachmentRow(for: item)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.theme.background)
        .navigationTitle("Attachments")
    }
    
    @ViewBuilder
    private func attachmentRow(for item: Attachment) -> some View {
        HStack {
            Image(systemName: getIcon(for: item))
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(item.type.rawValue.capitalized)
                    .font(.body)
                Text(item.url)
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
    }
    
    private func getIcon(for attachment: Attachment) -> String {
        switch attachment.type {
        case .image:
            return "photo"
        case .video:
            return "video"
        case .document:
            return "text.document"
        }
    }
}


#Preview {
    
    NavigationStack {
        IssueTimelineView(reportId: "")
        //of: .resolution
        
        Button("showJson") {
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(Resolution.resolution)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Error encoding user: \(error)")
            }
        }
    }
}

// MARK: - Mock Data Extension
extension Resolution {
    static let resolution = Resolution(
        status: "fixed",
        id: "SV-SS-260601-aXWsaxls",
        history: IssueHistory(
            reported: Milestone(
                date: "2026-04-17",
                by: "John Doe",
                comments: "Deep pothole in the middle of the street.",
                attachments: []
            ),
            confirmed: Milestone(
                date: "2026-04-18",
                by: "Jane Doe",
                comments: "Verified by 10 neighbors.",
                attachments: []
            ),
            inProgress: InProgressMilestone(
                assignedInstitution: "MOP, Ministerio de Obras Públicas",
                updates: [
                    IssueUpdate(
                        id: "u1",
                        date: "2026-04-19",
                        by: "Repórtamelo Team",
                        comments: "Issue assigned to MOP.",
                        status: "started",
                        attachments: []
                    ),
                    IssueUpdate(
                        id: "u2",
                        date: "2026-04-21",
                        by: "MOP",
                        comments: "Budget approved for heavy machinery.",
                        status: "approved",
                        attachments: [
                            Attachment(id: "", type: .document, createdAtRaw: Int64(Date().timeIntervalSince1970 * 1000), updatedAtRaw: Int64(Date().timeIntervalSince1970 * 1000), uploaderUserName: "", validatedAtRaw: Int64(Date().timeIntervalSince1970 * 1000), validatedBy: .citizen, state: .confirmed, notes: "", key: "", fileName: "", reportContainer: ""),
                        ]
                    ),
                    IssueUpdate(
                        id: "u3",
                        date: "2026-04-23",
                        by: "MOP",
                        comments: "Repair crew on site.",
                        status: "inProgress",
                        attachments: []
                    )
                ]
            ),
            fixed: Milestone(
                date: "2026-04-26",
                by: "MOP",
                comments: "The road has been successfully repaved.",
                attachments: [
                    Attachment(id: "", type: .document, createdAtRaw: Int64(Date().timeIntervalSince1970 * 1000), updatedAtRaw: Int64(Date().timeIntervalSince1970 * 1000), uploaderUserName: "", validatedAtRaw: Int64(Date().timeIntervalSince1970 * 1000), validatedBy: .citizen, state: .confirmed, notes: "", key: "", fileName: "", reportContainer: ""),
                ]
            ),
        ),
        metadata: ResolutionMetadata(cityId: "", groupingId: "", assigned: .init(institutionName: "", institutionCode: "", institutionId: ""), resourceType: "", resourceId: "")
    )
}
