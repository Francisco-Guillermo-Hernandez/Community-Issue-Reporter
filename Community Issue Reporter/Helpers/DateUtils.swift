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
    formatter.unitsStyle = .full // Options: .short, .abbreviated, .full
    
    return formatter.localizedString(for: date, relativeTo: Date())
}
