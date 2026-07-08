//
//  MyFindingsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI

struct InsightsView: View {
    @Namespace private var insightsNamespace
    @State private var controller = InsightsController()
 
    var body: some View {
        NavigationStack(path: $controller.navigationPath) {
            ZStack(alignment: .top) {
                
                Color.theme.background
                    .ignoresSafeArea()
                
                Color.orange.opacity(0.321)
                    .frame(height: 280)
                    .mask(
                        LinearGradient(
                            colors: [.white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 70)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView(.vertical) {
                        StatsCardsView(path: $controller.navigationPath, nameSpace: insightsNamespace, insights: controller.insights)
                            .padding(.bottom, 48)
                           
                        InsightsCalendarView(path: $controller.navigationPath, activityData: controller.insights.recentActivity)
                    }
                }
                .navigationDestination(for: InsightsNavigation.self) { destination in
                    switch destination {
                        case .myReports:
                            MyReportsSubView(path: $controller.navigationPath, subViewName: "My reports")
                                .navigationTransition(.zoom(sourceID: "transition:myReports", in: insightsNamespace))
                        case .myPetitions:
                            MyPetitionsSubView(path: $controller.navigationPath, subViewName: "My petitions")
                                .navigationTransition(.zoom(sourceID: "transition:myPetitions", in: insightsNamespace))
                        case .activity(let date):
                            SimpleView(
                                title: "ActivityListView",
                                selectedDay: controller.insights.recentActivity[date],
                                dateFormatter: date
                            )
                        case .noActivity:
                            SimpleView(title: "NoActivityView")
                        case .report(let report):
                            SimpleView(title: report.title)
                        case .petition(let petition):
                            SimpleView(title: petition.title)
                    
                    }
                }
                .task {
                    await controller.getInsights()
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Insights")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
        }
    }
}
#Preview {
    InsightsView()
}
