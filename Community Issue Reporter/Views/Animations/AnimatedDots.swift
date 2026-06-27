//
//  AnimatedDots.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/6/26.
//

import SwiftUI

struct AnimatedDotsModifier: ViewModifier {
    @State private var dotCount = 1
    var animate: Bool = true
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            content
            
            /// prevents layout shifting by reserving the max width
            ZStack(alignment: .leading) {
                /// Invisible max-length string to reserve space
                Text("....")
                    .opacity(0)
                
                /// The actual animated dots
                Text(String(repeating: ".", count: dotCount))
            }
        }
        .task {
            /// Run an infinite loop as long as the view is alive
            while !Task.isCancelled && animate {
                /// Sleep for 250 milliseconds (250,000,000 nanoseconds)
                try? await Task.sleep(nanoseconds: 450_000_000)
                
                /// Increment dots: 1 -> 2 -> 3 -> 4 -> 1 ...
                dotCount = (dotCount % 4) + 1
            }
        }
    }
}

// MARK: - View Extension
extension View {
    /// Appends animated dots (from 1 to 4) to the trailing edge of the view.
    func animatedDots(animate: Bool) -> some View {
        self.modifier(AnimatedDotsModifier(animate: animate))
    }
}
