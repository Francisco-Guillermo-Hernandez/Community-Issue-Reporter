//
//  DashboardController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/11/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class DashboardController {
    
    static var shared = DashboardController()
    var path: [DashboardNavigation] = []
    
    var windowSize: CGSize = .zero
    
    init() {
        
    }
    
}
