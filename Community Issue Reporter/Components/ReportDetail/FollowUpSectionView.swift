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
    var resolution: Resolution?
    
    init(for report: MapExplorerReport, resolution: Resolution? = nil) {
        self.report = report
        self.resolution = resolution
    }
    
    private var isFollowUpDisabled: Bool {
        report.institutionId == nil || report.assignedTo == nil
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "Follow up"))
                .padding(.bottom, -10)
            
            List {
                NavigationLink(destination: IssueTimelineView(resolution: resolution ?? .resolution)) {
                    HStack {
                        Text("Details of the progress")
                            .font(.caption)
                            .opacity(isFollowUpDisabled ? 0.4 : opacity)
                            .fontWeight(.medium)
                        
                    }
                }
                .disabled(isFollowUpDisabled)
                .listRowBackground(Color.clear)
                
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
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 75)
        }
        .padding(.bottom, .themePadding)
    }
}

#Preview {
    ScrollView {
        FollowUpSectionView(for: MapExplorerMockedData.shared.report)
    }
    .background(Color.theme.background)
}
