//
//  Logger+Extension.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/4/26.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}


class L {
    func Notice() -> Void {
        Logger.viewCycle.notice("")
    }
}
