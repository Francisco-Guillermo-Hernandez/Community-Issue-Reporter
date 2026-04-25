//
//  CustomChartSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/4/26.
//

import Charts
import SwiftUI
//
struct CustomChartSubView: View {
    
    
    
    var body: some View {
        StatsCardView(stats: .from(json: [
            "total_reports": 77,
            "january": ["count": 1],
            "february": ["count": 2],
            "march": ["count": 1],
            "april": ["count": 4],
            "may": ["count": 5],
            "june": ["count": 6],
            "july": ["count": 7],
            "august": ["count": 8],
            "september": ["count": 9],
            "october": ["count": 10],
            "november": ["count": 11],
            "december": ["count": 12]
        ]))
    }
}

#Preview {
    CustomChartSubView()
}


import SwiftUI
import Charts

// MARK: - Data Models
struct MonthlyData: Identifiable {
    let id = UUID()
    let month: Int // 1 to 12
    let count: Int
    
    var date: Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: month)) ?? Date()
    }
}

struct StatsSummary {
    let totalEntries: Int
    let monthlyBreakdown: [MonthlyData]
}

// MARK: - View
struct StatsCardView: View {
    let stats: StatsSummary
    

    private let cardBackground = Color(red: 0.45, green: 0.48, blue: 0.85)
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
    
            VStack(alignment: .leading, spacing: 0) {
                Text("\(stats.totalEntries)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                
                Text("Entries")
                    .font(.title2.bold())
                
                Text("This Year")
                    .font(.title3)
                    .opacity(0.6)
            }
//            .foregroundColor(.white)
            .foregroundStyle(Color.init(hex: "121212"))
            .frame(maxWidth: .infinity, alignment: .leading)
            
         
            Chart {
                ForEach(stats.monthlyBreakdown) { data in
                    BarMark(
                        x: .value("Month", data.date, unit: .month),
                        y: .value("Count", data.count),
                        width: .fixed(4)
                    )
                    .foregroundStyle(Color.init(hex: "1a181b"))
                    .cornerRadius(2)
                }
            }
            .chartYAxis {
                AxisMarks(values: [0, 5, 10]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.init(hex: "1a181b").opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(Color.init(hex: "1a181b").opacity(0.5))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                  
                    AxisValueLabel(format: .dateTime.month(.narrow))
                        .foregroundStyle(Color.init(hex: "1a181b").opacity(0.7))
                }
            }
            .frame(height: 120)
        }
        .padding(24)
        .background(Color.init(hex: "618b8c"))
        .cornerRadius(24)
//        .padding()
    }
}

// MARK: - Integration Helper
extension StatsSummary {
    static func from(json: [String: Any]) -> StatsSummary {
        let total = json["total_reports"] as? Int ?? 0
        let months = [
            "january", "february", "march", "april", "may", "june",
            "july", "august", "september", "october", "november", "december"
        ]
        
        let breakdown = months.enumerated().map { index, name in
            let monthDict = json[name] as? [String: Any]
            return MonthlyData(month: index + 1, count: monthDict?["count"] as? Int ?? 0)
        }
        
        return StatsSummary(totalEntries: total, monthlyBreakdown: breakdown)
    }
}

// MARK: - Preview
//struct StatsCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            StatsCardView(stats: .from(json: [
//                "total_reports": 78,
//                "january": ["count": 3],
//                "february": ["count": 2],
//                "march": ["count": 1],
//                "april": ["count": 4],
//                "may": ["count": 5],
//                "june": ["count": 6],
//                "july": ["count": 7],
//                "august": ["count": 8],
//                "september": ["count": 9],
//                "october": ["count": 10],
//                "november": ["count": 11],
//                "december": ["count": 12]
//            ]))
//        }
//    }
//}
