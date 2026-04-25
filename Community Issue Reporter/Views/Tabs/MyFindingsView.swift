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
    
        private var dateFormatter: DateFormatter {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            return f
        }
    @State private var date = Date()
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var nameSpace
    @State private var selectedOption: String = "My Reports"
    let options: [String] = ["My Reports", "My Petitions", "Signed Petitions"]

    var body: some View {
        NavigationStack {
            VStack {
       
                ScrollView(.vertical) {
                    
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
                       
                        
                    
                    InsightsCalendarView(activityData: MockData.activityMap)
//                        .listRowInsets(EdgeInsets())
//                        .listRowSeparator(.hidden)
//                        .fill(colorScheme == .dark ? Color.white: Color.black)
                    
//                        .padding(.horizontal, 30)
                        
                        
//                        .frame(maxWidth: .infinity)
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                        .padding(.horizontal, 30)
//                                    .background(Color.white)
//                                    .cornerRadius(20)
                    
//                        .listRowInsets(EdgeInsets())
//                               .listRowBackground(Color.clear)
//                               .frame(height: 300)
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
