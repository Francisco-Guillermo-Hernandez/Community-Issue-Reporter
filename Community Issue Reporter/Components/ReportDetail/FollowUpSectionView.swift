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
                          .opacity(0.85)
                          .fontWeight(.medium)
                         
                  }
              }
                .listRowBackground(Color.clear)
                
                HStack {
                    Text("Assigned institution:")
                        .font(.caption)
                        .opacity(0.85)
                        .fontWeight(.medium)
                        
                    Spacer()
                    Text("MOP")
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
        FollowUpSectionView()
    }
    .background(Color.theme.background)
}
