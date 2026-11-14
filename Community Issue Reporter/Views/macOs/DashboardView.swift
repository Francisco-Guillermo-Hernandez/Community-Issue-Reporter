//
//  DashboardView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 6/11/26.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var preferredColumn: NavigationSplitViewColumn = .detail
    @State private var controller = DashboardController.shared
    
    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                Section {
                    ForEach(DashboardNavigation.mainPages) { page in
                        NavigationLink(value: page) {
                            Label(page.name, systemImage: page.symbolName)
                        }

                    }
                }
            }
            .navigationDestination(for: DashboardNavigation.self) { page in
                viewForPage(page)
            }
            .frame(minWidth: 150)
            
            
        } detail: {
            
            NavigationStack(path: $controller.path) {
                MapExplorerView()
            }
            .navigationDestination(for: DashboardNavigation.self) { page in
                viewForPage(page)
            }
            
        }
    }
    
    @ViewBuilder func viewForPage(_ page: DashboardNavigation) -> some View {
        switch page {
            case .profile: UserProfileView()
            case .reports: MapExplorerView()
        }
    }
}

#Preview {
    
    @Previewable @State var controller = DashboardController.shared
    
    DashboardView()
        .environmentObject(AuthViewModel())
        .environment(DeepLinkRouter())
        .environment(SettingsStore())
        .environment(NotificationManager())
        .environment(NetworkMonitor())
        .environment(SubscriptionManager.shared)
        .onGeometryChange(for: CGSize.self) { geometry in
            geometry.size
        } action: {
            controller.windowSize = $0
        }
}
