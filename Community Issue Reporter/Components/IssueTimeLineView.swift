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
                // The "Station" dot
                ZStack {
                    Circle()
                        .fill(status.color)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                }
                
                // The "Rail" line
                if !isLast {
                    Rectangle()
                        .fill(status.color.opacity(0.5))
                        .frame(width: 4)
                        .cornerRadius(2)
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
    let report: IssueReport
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Issue #\(report.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
                
                // 1. Reported
                TimelineNode(status: .reported) {
                    MilestoneHeader(title: "Reported", date: report.history.reported?.date)
                    Text("By \(report.history.reported?.by ?? "Unknown")").font(.subheadline)
                }
                
                // 2. Confirmed
                if let confirmed = report.history.confirmed {
                    TimelineNode(status: .confirmed) {
                        MilestoneHeader(title: "Confirmed", date: confirmed.date ?? confirmed.computedConfirmationDate)
                        Text("Issue verified by the community").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                
                // 3. In Progress (Expanded Sub-tasks)
                if let inProgress = report.history.inProgress {
                    TimelineNode(status: .inProgress) {
                        VStack(alignment: .leading, spacing: 12) {
                            MilestoneHeader(title: "In Progress", date: nil)
                            Text(inProgress.assignedInstitution)
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            // Sub-steps (Updates)
                            VStack(alignment: .leading, spacing: 15) {
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
                
                // 4. Fixed
                if let fixed = report.history.fixed {
                    TimelineNode(status: .fixed, isLast: true) {
                        VStack(alignment: .leading) {
                            MilestoneHeader(title: "Fixed", date: fixed.date)
                            Text(fixed.comments ?? "Repair finalized").font(.subheadline)
                            
                            if let attachments = fixed.attachments {
                                NavigationLink(destination: AttachmentDetailView(attachments: attachments)) {
                                    HStack {
                                        Image(systemName: "checkmark.seal.fill")
                                        Text("View Final Evidence")
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
        .navigationTitle("Issue Resolution")
        .background(Color(UIColor.systemBackground))
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
                Image(systemName: item.type == "image" ? "photo" : "doc.text")
                    .frame(width: 30)
                VStack(alignment: .leading) {
                    Text(item.type.capitalized)
                        .font(.body)
                    Text(item.url)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Attachments")
    }
}


#Preview {
    NavigationStack {
        IssueTimelineView(report: .mockReport)
    }
}

// MARK: - Mock Data Extension
extension IssueReport {
    static let mockReport = IssueReport(
        status: "fixed",
        id: "0001",
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
                            Attachment(id: "a1", type: "document", url: "https://mop.gov/budget_001.pdf")
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
                    Attachment(id: "a2", type: "image", url: "https://example.com/fixed_road.jpg")
                ]
            )
        )
    )
}
