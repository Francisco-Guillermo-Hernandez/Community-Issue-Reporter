//
//  FollowUpSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI

struct FollowUpSectionView: View {
    @State private var opacity: Double = 0.85
    
    var report: MapExplorerReport
    @Binding var voteCount: Int
    init(for report: MapExplorerReport, _ voteCount: Binding<Int>) {
        self.report = report
        self._voteCount = voteCount
    }
    
    private var isFollowUpDisabled: Bool {
        report.institutionId == nil || report.assignedTo == nil
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "Follow up"))
                .padding(.bottom, -10)
            
            List {
            
                if voteCount > 0 {
                    HStack {
                        Text("**\(voteCount)** citizen have boosted this report to be resolved.")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .listRowBackground(Color.clear)
                }
                
                HStack {
                    Text("Assigned institution:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                    
                    Spacer()
                    Text(report.assignedInstitution)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)
                
                HStack {
                    Text("Assignation date:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                    
                    Spacer()
                    Text(report.assignedDate)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)
                
                NavigationLink(destination: IssueTimelineView(reportId: report.id)) {
                    HStack {
                        Text("Details of the progress")
                            .font(.caption)
                            .opacity(opacity)
                            .fontWeight(.medium)
                    }
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 135)
        }
        .padding(.bottom, .themePadding)
    }
}

#Preview {
    
    @Previewable @State var count: Int = 0
    ScrollView {
        FollowUpSectionView(for: MapExplorerMockedData.shared.report, $count)
    }
    .background(Color.theme.background)
}
