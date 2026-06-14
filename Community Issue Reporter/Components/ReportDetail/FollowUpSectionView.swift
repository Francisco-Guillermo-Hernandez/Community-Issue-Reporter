//
//  FollowUpSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI

struct FollowUpSectionView: View {
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "Follow up"))
                .padding(.bottom, -10)
            
            List {
                NavigationLink(destination:  IssueTimelineView(report: .mockReport)) {
                  HStack {
                      Text("Details of the progress")
                          .font(.caption)
                         
                  }
              }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 30)
        }
        .padding(.bottom, .themePadding)
    }
}

#Preview {
    FollowUpSectionView()
}
