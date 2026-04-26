//
//  MyFindingsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI


struct MyFindingsView: View {
    @State private var selectedDate = Date()
    @State private var activityData: [String: DaySummary] = [:]
    @State private var navigationPath = NavigationPath()
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    @State private var date = Date()
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedOption: String = "My Reports"
    let options: [String] = ["My Reports", "My Petitions", "Signed Petitions"]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
       
                ScrollView(.vertical) {
                    
                    StatsCardsView()
                        .padding(.bottom, 48)
                       
                    InsightsCalendarView(path: $navigationPath, activityData: MockData.activityMap)
                }

                
            }
            .navigationTitle("Insights")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}
#Preview {
    MyFindingsView()
}
