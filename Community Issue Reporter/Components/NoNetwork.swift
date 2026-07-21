//
//  NoNetwork.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/7/26.
//

import SwiftUI

struct NoNetwork: View {
    var retry: () -> Void
    var body: some View {
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
               retry()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}


#Preview {
    NoNetwork() {
        
    }
}
