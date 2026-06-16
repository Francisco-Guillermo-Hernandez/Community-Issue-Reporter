//
//  MapWithClustering.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI
import MapKit

struct MapWithClustering: View {
    @EnvironmentObject var appState: AuthViewModel
    @ObservedObject var manager: MapManager
    @State private var selectedPlaceID: String?
    @State private var expandedItem: MapExplorerReport?
    private let animation = Animation.easeInOut(duration: 0.25)
    
    var body: some View {
        Map(position: $appState.cameraPosition) {
            ForEach(manager.renderedClusters) { cluster in
                Annotation(cluster.isCluster ? "\(cluster.totalCount) Reports" : "Report", coordinate: cluster.coordinate) {
                    ZStack {
                        if cluster.isCluster {
                            // Custom UI for a group of items
                            ZStack {
                                Circle()
                                    .fill(Color.theme.primary)
                                    .frame(width: 40, height: 40)
                                
                                Text("\(cluster.totalCount)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        } else {
                            if let report = cluster.originalReport {
                                annotationView(report)
                            }
                        }
                    }
                }
            }
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            manager.updateVisibleRegion(rect: context.rect)
        }
        .task {
            await manager.fetchReports()
        }
        .sheet(item: $expandedItem) { report in
            DetailView(report: report)
        }
    }
    
    @ViewBuilder
    private func annotationView(_ issue: MapExplorerReport) -> some View {
        let isSelected = issue.id == selectedPlaceID
        
        Image(systemName: issue.issueType.iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.black)
            .padding(isSelected ? 8 : 3)
            .frame(width: isSelected ? 50 : 20, height: isSelected ? 50 : 20)
            .background {
                Circle()
                    .fill(.white)
                    .padding(-1)
            }
            .animation(animation, value: isSelected)
            .background {
                if isSelected {
                    PulseRingView(tint: issue.status.color, size: 80)
                }
            }
            .contentShape(.rect)
            .onTapGesture {
                expandedItem = issue
    //                showDetailView.toggle()
                withAnimation(animation) {
                    selectedPlaceID = issue.id
                }
            }
    }
}



#Preview {
    let manager = MapManager()
    MapWithClustering(manager: manager)
        .environmentObject(AuthViewModel())
}
