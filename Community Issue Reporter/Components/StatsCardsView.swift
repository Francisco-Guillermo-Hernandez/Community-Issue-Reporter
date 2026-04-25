//
//  StatsCardsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI

struct StatsCardsView: View {
    @Namespace private var nameSpace
    var body: some View {
        VStack(spacing: .themeSpacing * 2) {
            HStack(spacing: .themeSpacing * 2) {
                NavigationLink {
                    MyReportsSubView(subViewName: "My reports")
                        .navigationTransition(.zoom(sourceID: "transition:myReports", in: nameSpace))
                    
                } label: {
                    CardInfoRow(
                        data: CardInfoModelView(
                            title: "Reports",
                            subtitle: "This month",
                            stat: "03"
                        ),
                        action: {}
                    )
                    .matchedTransitionSource(id: "transition:myReports", in: nameSpace) { configuration in
                        configuration
                            .background(Color.theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                    }
                    
                }
                
                NavigationLink {
                    MyPetitionsSubView(subViewName: "My petitions")
                        .navigationTransition(.zoom(sourceID: "transition:myPetitions", in: nameSpace))
                } label: {
                    CardInfoRow(
                        data: CardInfoModelView(
                            title: "Petitions",
                            subtitle: "This month",
                            stat: "04"
                        ),
                        action: { }
                    )
                    .matchedTransitionSource(id: "transition:myPetitions", in: nameSpace) { configuration in
                        configuration
                            .background(Color.theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                    }
                }
                
            }
            
            CustomChartSubView()

                .clipShape(RoundedRectangle(cornerRadius: .themeCardCornerRadius, style: .continuous))
                .contextMenu {
                    Button("Action 1") { }
                    Button("Action 2") { }
                }
               
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

#Preview {
    NavigationStack {
        StatsCardsView()
    }
}
