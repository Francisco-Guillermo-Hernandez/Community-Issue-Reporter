//
//  StatsCardsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI

struct StatsCardsView: View {
    @Binding var path: [InsightsNavigation]
    var nameSpace: Namespace.ID
    var insights: MonthlyInsightsResponse
    
    var body: some View {
        VStack(spacing: .themeSpacing * 2) {
            HStack(spacing: .themeSpacing * 2) {
                
                NavigationLink(value: InsightsNavigation.myReports) {

                    StatCard(
                        description: String(localized: "I've reported"),
                        title: String(insights.totalReports),
                        trend: String(localized: "Issues this month"),
                        timeframe: ""
                    )
                }
                .matchedTransitionSource(id: "transition:myReports", in: nameSpace) { configuration in
                    configuration
                        .background(Color.theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                }
                
                NavigationLink(value: InsightsNavigation.myPetitions) {
                    StatCard(
                        description: String(localized: "I've created"),
                        title: String(insights.totalPetitions),
                        trend: String(localized: "Petitions this month"),
                        timeframe: "for the last 6 months"
                    )
                }
                .matchedTransitionSource(id: "transition:myPetitions", in: nameSpace) { configuration in
                    configuration
                        .background(Color.theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                }
            }
            
            HStack {
                StatCard(
                    description: String(localized: "I've commented on"),
                    title: String(insights.totalComments),
                    trend: String(localized: "Petitions"),
                    timeframe: "for the last 6 months"
                )
                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                
                StatCard(
                    description: String(localized: "I've signed on"),
                    title: String(insights.totalSignatures),
                    trend: String(localized: "Incidents"),
                    timeframe: "for the last 6 months"
                )
                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
            }
            
            
//            CustomChartSubView()
//                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

#Preview {
    @Previewable @Namespace var nameSpace
    @Previewable @State var path: [InsightsNavigation] = []
    NavigationStack(path: $path) {
        ZStack {
            Color.theme.background
            StatsCardsView(
                path: $path,
                nameSpace: nameSpace,
                insights: MonthlyInsightsResponse(
                    totalReports: 0,
                    totalSignatures: 0,
                    totalComments: 0,
                    totalPetitions: 1,
                    recentActivity: [:]
                )
            )
        }
    }
    .navigationDestination(for: InsightsNavigation.self) { destination in
        Text("Destination for \(String(describing: destination))")
    }
}
