//
//  DateUtils.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 19/4/26.
//

import Foundation

func parsePostgresDate(_ dateString: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: dateString)
}


func formatRelativeDate(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short // Options: .short, .abbreviated, .full
    
    return formatter.localizedString(for: date, relativeTo: Date())
}

func applyFormat(_ timestamp: String?) -> String {
    if let timestamp {
        var relativeTime: String {
                guard let date = parsePostgresDate(timestamp) else { return "Invalid date" }
                return formatRelativeDate(from: date)
        }
        
        return relativeTime
    }
    
    return "Never"
}


enum DateFormat {
    case dashed
    case joined
}

func createdAtNow(format: DateFormat) -> String {
    let verbatim: Date.FormatString = format == .joined ?  "\(year: .extended())\(month: .twoDigits)\(day: .twoDigits)" : "\(year: .extended())\(month: .twoDigits)-\(day: .twoDigits)"
    
     return Date()
        .formatted(
            .verbatim(verbatim, timeZone: .current, calendar: .current)
    )
}


func getMonthName() -> String {
    
    let englishLocale = Locale(identifier: "en")

    return Date()
        .formatted(.dateTime.month(.wide)
        .locale(englishLocale))
        .lowercased()
}

func getFullYear() -> String {
    return  Date()
        .formatted(.dateTime.year())
}


extension Date {
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func reduceDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self) ?? self
    }
}


