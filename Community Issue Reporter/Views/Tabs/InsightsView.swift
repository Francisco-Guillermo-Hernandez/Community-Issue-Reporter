//
//  MyFindingsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI


struct InsightsView: View {
    @Namespace private var insightsNamespace
    @State private var selectedDate = Date()
    @State private var activityData: [String: DaySummary] = MockData.activityMap
    @State private var navigationPath: [InsightsNavigation] = []
    
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
                    StatsCardsView(path: $navigationPath, nameSpace: insightsNamespace)
                        .padding(.bottom, 48)
                       
                    InsightsCalendarView(path: $navigationPath, activityData: activityData)
                }
            }
            .navigationDestination(for: InsightsNavigation.self) { destination in
                switch destination {
                case .myReports:
                    MyReportsSubView(subViewName: "My reports")
                        .navigationTransition(.zoom(sourceID: "transition:myReports", in: insightsNamespace))
                case .myPetitions:
                    MyPetitionsSubView(subViewName: "My petitions")
                        .navigationTransition(.zoom(sourceID: "transition:myPetitions", in: insightsNamespace))
                case .activity(let date):
                    SimpleView(
                        title: "ActivityListView",
                        selectedDay: activityData[date],
                        dateFormatter: date
                    )
                case .noActivity:
                    SimpleView(title: "NoActivityView")
                }
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Insights")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}
#Preview {
    InsightsView()
}
