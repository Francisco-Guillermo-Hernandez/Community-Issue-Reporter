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
                
               
//                Button {
//                    path.append(.myReports)
//                } label: {
//                    CardInfoRow(
//                        data: CardInfoModelView(
//                            title: "Reports",
//                            subtitle: "This month",
//                            stat: "03"
//                        ),
//                        action: {}
//                    )
//                }
//                .buttonStyle(.plain)
//                .matchedTransitionSource(id: "transition:myReports", in: nameSpace) { configuration in
//                    configuration
//                        .background(Color.theme.primary)
//                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
//                }
                
                NavigationLink(value: InsightsNavigation.myReports) {
//                    CardInfoRow(
//                        data: CardInfoModelView(
//                            title: "Reports",
//                            subtitle: "This month",
//                            stat: "03"
//                        ),
//                        action: {}
//                    )
                    StatCard(
                        action: {},
                        description: "I've reported",
                        title: "50",
                        trend: "Issues this month",
                        timeframe: ""
                    )
                }
//                .buttonStyle(.plain)
                .matchedTransitionSource(id: "transition:myReports", in: nameSpace) { configuration in
                    configuration
//                        .background(Color.theme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                }
                
                NavigationLink(value: InsightsNavigation.myPetitions) {
//                    CardInfoRow(
//                        data: CardInfoModelView(
//                            title: "Petitions",
//                            subtitle: "This month",
//                            stat: "04"
//                        ),
//                        action: {}
//                    )
                    StatCard(
                        action: {},
                        description: "I've created",
                        title: "50",
                        trend: "Petitions to sign",
                        timeframe: "for the last 6 months"
                    )
                }
//                .buttonStyle(.plain)
                .matchedTransitionSource(id: "transition:myPetitions", in: nameSpace) { configuration in
                    configuration
//                        .background(Color.theme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                }
                
                
          
                
//                Button {
//                    path.append(.myPetitions)
//                } label: {
//                    CardInfoRow(
//                        data: CardInfoModelView(
//                            title: "Petitions",
//                            subtitle: "This month",
//                            stat: "04"
//                        ),
//                        action: { }
//                    )
//                }
//                .buttonStyle(.plain)
//                .matchedTransitionSource(id: "transition:myPetitions", in: nameSpace) { configuration in
//                    configuration
//                        .background(Color.theme.primary)
//                        .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
//                }
            }
            
            HStack {
                StatCard(
                    action: {},
                    description: "I've signed",
                    title: "10",
                    trend: "Petitions",
                    timeframe: "for the last 6 months"
                )
                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                
                StatCard(
                    action: {},
                    description: "I've commented on",
                    title: "100",
                    trend: "Incidents",
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
        StatsCardsView(path: $path, nameSpace: nameSpace)
    }
    .navigationDestination(for: InsightsNavigation.self) { destination in
        Text("Destination for \(String(describing: destination))")
    }
}
