//
//  Logger+Extension.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 1/4/26.
//

import OSLog
import Foundation

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}

// MARK: -
protocol DataLogger {
    associatedtype T
    func log(data: T)
}

var disableLogs: Bool = false

struct LogDetail {
    var viewName: String
    var methodName: String?
    var data: String?
    
    init(viewName: String, methodName: String? = nil, data: String? = nil) {
        self.viewName = viewName
        self.methodName = methodName
        self.data = data
    }
}

struct JSONLogger<T: Encodable>: DataLogger {
    func log(data: T) {
        if let encoded = try? JSONEncoder().encode(data),
           let jsonString = String(data: encoded, encoding: .utf8) {
            print("JSON LOG: \(jsonString)")
        }
    }
}


struct StringLogger: DataLogger {
    typealias T = String
    
    func log(data: String) {
        print("LOG: \(data)")
    }
}


// MARK: -

//struct L {
//    static func info()
//}
