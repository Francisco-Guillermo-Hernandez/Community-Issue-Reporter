//
//  InsightsCalendarView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/4/26.
//

import SwiftUI

struct InsightsCalendarView: View {
    @Binding var path: [InsightsNavigation]
    @State private var selectedDate: Date = .init()
    @State private var showDetails: Bool = true
    
    var activityData: [String: DaySummary] = [:]
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    var body: some View {
        VStack {
            CustomCalendar(selectedDate: $selectedDate, activityMap: activityData) { date in
                selectionHandler(date)
            }
            .frame(height: 400)
        }
    }
    
    private func selectionHandler(_ date: Date) {
        self.selectedDate = date
        let dateFormatted = dateFormatter.string(from: date)
        if let _ = activityData[dateFormatted] {
            path.append(InsightsNavigation.activity(date: dateFormatted))
        } else {
            path.append(InsightsNavigation.noActivity)
        }
        
    }
}


struct SimpleView: View {
    var title: String
    var selectedDay: DaySummary? = nil
    var dateFormatter: String = ""
    
    private var localizedDateString: String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd"
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.calendar = Calendar(identifier: .gregorian)
        
        guard let date = parser.date(from: dateFormatter) else {
            return dateFormatter
        }
        
        return date.formatted(date: .long, time: .omitted)
    }
    
   var body: some View {
       
       ZStack(alignment: .top) {
           
           Color.theme.background
               .ignoresSafeArea()
           
           Color.orange.opacity(0.121)
               .frame(height: 180)
               .mask(
                LinearGradient(
                    colors: [.white, .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
               )
               .blur(radius: 70)
               .ignoresSafeArea()
           
           Group {
               VStack {
                   if title == "NoActivityView" {
                       ContentUnavailableView {
                           Label(String(localized: "No activity"), systemImage: "calendar.badge.exclamationmark")
                               .symbolRenderingMode(.palette)
                               .foregroundStyle(
                                    Color.theme.foreground.opacity(0.7),
                                    Color.theme.primary,
                                    Color.theme.foreground.opacity(0.7)
                               )
                       } description: {
                           Text("You didn't create any reports on this day.")
                               .foregroundStyle(Color.theme.primary)
                       }
                       
                   } else {
                       if selectedDay != nil {
                           
                           List {
                               
                               Section {
                                   if let reports = selectedDay?.reports, !reports.isEmpty {
                                       ForEach(reports, id: \.id) { report in
                                           Text(report.id)
                                               .cellStyle()
                                       }
                                   } else {
                                       Text("No reports available")
                                           .foregroundColor(.secondary)
                                           .font(.caption)
                                           .padding(.horizontal)
                                   }
                               } header: {
                                   Text(String(localized: "Reports"))
                               }
                               
                               Section {
                                   if let signatures = selectedDay?.signatures, !signatures.isEmpty {
                                       ForEach(signatures, id: \.id) { signature in
                                           Text(signature.id)
                                               .cellStyle()
                                       }
                                   } else {
                                       Text("No signatures available")
                                           .foregroundColor(.secondary)
                                           .font(.caption)
                                           .padding(.horizontal)
                                   }
                               } header: {
                                   Text(String(localized: "Signatures"))
                               }
                               
                               Section {
                                   if let signatures = selectedDay?.petitions, !signatures.isEmpty {
                                       ForEach(signatures, id: \.id) { signature in
                                           VStack {
                                               Text(signature.title)
                                                   .font(.caption)
                                                   .foregroundStyle(Color.secondary)
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                           }
                                           .frame(maxWidth: .infinity, alignment: .leading)
                                           .cellStyle()
                                       }
                                   } else {
                                       Text("No petitions available")
                                           .foregroundColor(.secondary)
                                           .font(.caption)
                                           .padding(.horizontal)
                                   }
                               } header: {
                                   Text(String(localized: "Petitions"))
                               }
                               
                               Section {
                                   if let signatures = selectedDay?.comments, !signatures.isEmpty {
                                       ForEach(signatures, id: \.id) { signature in
                                           VStack {
                                               Text(signature.title)
                                                   .font(.caption)
                                                   .foregroundStyle(Color.secondary)
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                           }
                                           .frame(maxWidth: .infinity, alignment: .leading)
                                           .cellStyle()
                                       }
                                   } else {
                                       Text("No comments available")
                                           .foregroundColor(.secondary)
                                           .font(.caption)
                                           .padding(.horizontal)
                                   }
                               } header: {
                                   Text(String(localized: "Comments"))
                               }
                           }
                           .listStyle(.insetGrouped)
                           
                           
                       }
                   }
               }
           }
       }
       .scrollContentBackground(.hidden)
       .toolbarTitleDisplayMode(.inline)
       .navigationBarTitle(dynamicTitle)
    }
    
    private var dynamicTitle: String {
        if title == "NoActivityView" {
            return String(localized: "No Activity")
        } else {
            return localizedDateString
        }
    }
}


struct MockData {

    static let activityMap: [String: DaySummary] = [
        "2026-07-07": DaySummary(
            interactions: 1,
            reports: [
                BasicInfo(id: "1", title: "demo", status: "demo")
            ],
            signatures: [],
            comments: [],
            petitions: []
        )
    ]
    
    // Mock for your "Cards" (Journaled/Written)
    static let stats = InsightsResponse(
        activityDays: activityMap,
        totalReports: 24,
        totalSignatures: 12,
        data: [:]
    )
}

#Preview("Insights Dashboard - Data") {
    @Previewable @Namespace var nameSpace
    @Previewable @State var path: [InsightsNavigation] = []
    NavigationStack(path: $path) {
        InsightsCalendarView(path: $path, activityData: MockData.activityMap)
    }
    .navigationDestination(for: InsightsNavigation.self) { _ in
        Text("Destination")
    }
}

#Preview("Insights Dashboard - Empty") {
    @Previewable @Namespace var nameSpace
    @Previewable @State var path: [InsightsNavigation] = []
    NavigationStack(path: $path) {
        InsightsCalendarView(path: $path, activityData: [:])
    }
    .navigationDestination(for: InsightsNavigation.self) { _ in
        Text("Destination")
    }
}
