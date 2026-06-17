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
    
    var body: some View {
        VStack(spacing: .themeSpacing * 2) {
            HStack(spacing: .themeSpacing * 2) {
                
                NavigationLink(value: InsightsNavigation.myReports) {

                    StatCard(
                        action: {},
                        description: String(localized: "I've reported"),
                        title: "50",
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
                        action: {},
                        description: String(localized: "I've created"),
                        title: "50",
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
                    action: {},
                    description: String(localized: "I've commented on"),
                    title: "10",
                    trend: String(localized: "Petitions"),
                    timeframe: "for the last 6 months"
                )
                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                
                StatCard(
                    action: {},
                    description: String(localized: "I've signed on"),
                    title: "100",
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
            StatsCardsView(path: $path, nameSpace: nameSpace)
        }
    }
    .navigationDestination(for: InsightsNavigation.self) { destination in
        Text("Destination for \(String(describing: destination))")
    }
}
