//
//  InsightsCalendarView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/4/26.
//

import SwiftUI

struct InsightsCalendarView: View {
    @State private var path = NavigationPath()
    @State private var selectedDate: Date = .init()
    @State private var selectedDaySummary: DaySummary? = nil
    @State private var showDetails: Bool = true
    
    var activityData: [String: DaySummary] = [:]
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    CustomCalendar(selectedDate: $selectedDate, activityMap: activityData) { date in
                        selectionHandler(date)
                    }
                }

                .navigationDestination(for: String.self) { value in
                    if value == "NoActivityView" {
                        SimpleView(title: value)
                    } else {
                        
                        SimpleView(
                            title: "ActivityListView",
                            selectedDay: activityData[value]
                        )
                    }
                }
            }
            
        }
    }
    
    private func selectionHandler(_ date: Date) {
        self.selectedDate = date
        let dateFormatted = dateFormatter.string(from: date)
        if let result = activityData[dateFormatted] {
            self.selectedDaySummary = result
            path.append(dateFormatted)
        } else {
            path.append("NoActivityView")
        }
        
    }
}


struct SimpleView: View {
    var title: String
    var selectedDay: DaySummary? = nil
    
   var body: some View {
       Group {
           VStack {
               if title == "NoActivityView" {
                   ContentUnavailableView {
                       Label("No activity", systemImage: "calendar.badge.exclamationmark")
                           .symbolRenderingMode(.palette)
                           .foregroundStyle(
                                Color.theme.foreground.opacity(0.7),
                                Color.theme.primary,
                                Color.theme.foreground.opacity(0.7)
                           )
                   } description: {
                       Text("You didn't create any reports on this day.")
                           .foregroundStyle(Color.theme.primary)
                   } actions: {
                     
                   }
                   .background(Color.theme.background)
               } else {
                   if selectedDay != nil {
                       
                       List {
                           Section(header: Text("Reports")) {
                               if let reports = selectedDay?.reports, !reports.isEmpty {
                                   ForEach(reports, id: \.id) { report in
                                       Text(report.id)
                                   }
                               } else {
                                   Text("No reports available")
                                       .foregroundColor(.secondary)
                               }
                           }
                           
                           Section(header: Text("Signatures")) {
                               if let signatures = selectedDay?.signatures, !signatures.isEmpty {
                                   ForEach(signatures, id: \.id) { signature in
                                       Text(signature.id)
                                   }
                               } else {
                                   Text("No signatures available")
                                       .foregroundColor(.secondary)
                               }
                           }
                       }
                       .listStyle(.insetGrouped)
                       
                       
                   }
               }
           }
       }
      
       .toolbarTitleDisplayMode(.inline)
       .navigationBarTitle(title == "NoActivityView" ? "No Activity" : "demo")
    }
}


struct MockData {
    static let sampleComment = Comment(
        id: "2a832de2-3379-4f21-abbd-278c477c5206",
        created_at: Date(),
        updated_at: Date(),
        name: "Francisco Hernandez",
        report_id: "id-1",
        message: "este bache es peligroso y debe de arreglarse lo mas pronto posible",
    )
    
    static let activityMap: [String: DaySummary] = [
        "2026-04-10": DaySummary(
            count: 1,
            reports: [
                BasicInfo(id: "1", ids: ["id-1"])
            ],
            signatures: [
                BasicInfo(id: "1", ids: ["id-1"])
            ]
        ),
    ]
    
    // Mock for your "Cards" (Journaled/Written)
    static let stats = InsightsResponse(
        activity_days: activityMap,
        total_reports: 24,
        total_signatures: 12
    )
}




#Preview("Insights Dashboard - Data") {
    NavigationStack {
        InsightsCalendarView(activityData: MockData.activityMap)
    }
}

#Preview("Insights Dashboard - Empty") {
    NavigationStack {
        InsightsCalendarView(activityData: [:])
    }
}

#Preview("Comment Row") {
    List {
        CommentRow(
            name: MockData.sampleComment.name ?? "User",
            time: Date(),
            message: MockData.sampleComment.message
        )
    }
    .listStyle(.plain)
}


extension Date {
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func reduceDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self) ?? self
    }
}


