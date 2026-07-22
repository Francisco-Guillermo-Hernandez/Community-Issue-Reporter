//
//  IssueTimeLineView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

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


///
///


struct IssueTimelineView: View {
    let resolution: Resolution
    
    var body: some View {
        ScrollView {
           
            VStack(alignment: .leading, spacing: 0) {
//                DetailsHeader(title: "Report follow up", description: "ID #\(resolution.id)")
//                    .padding(.bottom, .themePadding * 1.5)
//                Text("ID #\(resolution.id)")
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//                    .padding(.bottom, 20)
                
                /// 1. Reported
                TimelineNode(status: .reported) {
                    MilestoneHeader(title: String(localized: "Reported"), date: resolution.history.reported?.date)
                    Text("By \(resolution.history.reported?.by ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                /// 2. Confirmed
                if let confirmed = resolution.history.confirmed {
                    TimelineNode(status: .confirmed) {
                        MilestoneHeader(title: String(localized: "Confirmed"), date: confirmed.date ?? confirmed.computedConfirmationDate)
                        Text("Issue verified by the community").font(.subheadline)
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
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .toolbarTitleDisplayMode(.large)
        .navigationTitle("Report follow up")
        .navigationSubtitle("ID: \(resolution.id)")
//        .background(Color.theme.background)
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

struct AttachmentDetailView: View {
    let attachments: [Attachment]
    
    var body: some View {
        List(attachments) { item in
            HStack {
                Image(systemName: getIcon(for: item))
                    .frame(width: 30)
                VStack(alignment: .leading) {
                    Text(item.type.rawValue.capitalized)
                        .font(.body)
                    Text(item.url)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Attachments")
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
        IssueTimelineView(resolution: .resolution)
        
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
                            Attachment(id: "", type: .document, createdAt: Date(), updatedAt: Date(), uploadedBy: "", ValidatedAt: Date(), validatedBy: .citizen, state: .confirmed, notes: "", url: "", previewUrl: ""),
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
                    Attachment(id: "", type: .document, createdAt: Date(), updatedAt: Date(), uploadedBy: "", ValidatedAt: Date(), validatedBy: .citizen, state: .confirmed, notes: "", url: "", previewUrl: ""),
                ]
            ),
        ),
        metadata: ResolutionMetadata(cityId: "", groupingId: "", assigned: .init(institutionName: "", institutionCode: "", institutionID: ""), resourceType: "", resourceId: "")
    )
}
