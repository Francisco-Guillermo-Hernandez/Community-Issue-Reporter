//
//  NoNetwork.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/7/26.
//

import SwiftUI

struct NoNetwork: View {
    @Environment(\.colorScheme) private var colorScheme
    var retry: () async -> Void
    var body: some View {
        VStack {
            ContentUnavailableView {
                Label(String(localized: "Network Unavailable"), systemImage: "wifi.slash")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.theme.foreground.opacity(0.7),
                        Color.theme.primary,
                        Color.theme.foreground.opacity(0.7)
                    )
            } description: {
                Text(String(localized: "Please check your internet connection and try again."))
            } actions: {
                Button("Retry") {
                    Task {
                        await retry()
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .background {
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.theme.secondary.mix(with: colorScheme == .dark ? .black : .white, by: 0.4).opacity(0.67),
                            Color.theme.background
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: geo.size.width * 0.54
                    )
                    
                }
            }
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    NoNetwork() {
        
    }
}
