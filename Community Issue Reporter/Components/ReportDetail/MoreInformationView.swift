//
//  MoreInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import CoreLocation
import SwiftUI

struct MoreInformationView: View {
    @State private var openInMaps: Bool = false
    @State private var opacity: Double = 0.85
    var report: MapExplorerReport
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "More Information"))
                .padding(.bottom, -10)
            List {

                HStack {
                    Text("Report Id:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                    Spacer()
                    Text(report.id)
                        .fontWeight(.semibold)
                        .font(.caption)
                }
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = report.id
                    } label: {
                        Label("Copy ID", systemImage: "document.on.document")
                    }
                }
                .listRowBackground(Color.clear)
                
                HStack {
                    Text("Reported by:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                        
                    Spacer()
                    Text("@\(report.reportedBy)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)
                
                
                HStack {
                    Text("Created on:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                       
                    Spacer()
                    Text(report.createdDate)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)
            
                HStack {
                    Text("Last update:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                       
                    Spacer()
                    Text(report.updatedDate)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)

                HStack {
                    Text("Assigned institution:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                        
                    Spacer()
                    Text("MOP")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)
                
                HStack {
                    Text("Address:")
                        .font(.caption)
                        .opacity(opacity)
                        .fontWeight(.medium)
                        
                    Spacer()
                    Text(report.address)
                        .lineLimit(2)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .listRowBackground(Color.clear)

                Button {
                    self.openInMaps.toggle()
                } label: {
                    HStack {
                        Text("Coordinates:")
                            .font(.caption)
                            .opacity(opacity)
                            .fontWeight(.medium)
                            
                        Spacer()
                        Text("\(report.lat)° *N*, \(abs(report.lng))° *W*")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .trailing
                            )
                            .background(Color.black.opacity(0.001))
                    }
                }
                .listRowBackground(Color.clear)
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .confirmationDialog(
                    "Coordinates",
                    isPresented: $openInMaps,
                    titleVisibility: .visible
                ) {
                    Button("Confirm", role: .confirm) {
                        Task {
                            openOnGoogleMaps()
                        }
                    }

                } message: {
                    Text("Do you want to open this on Google Maps?")
                }

            }
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .listRowBackground(Color.clear)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 345)
            .contentMargins(.all, 0, for: .scrollContent)

        }
    }
    
    fileprivate func openOnGoogleMaps() {
        let urlString =
            "comgooglemaps://?q=\(report.clLocation.latitude),\(report.clLocation.longitude)&zoom=14"
        if let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

}

#Preview {
    var report = MapExplorerReport(
        id: "SV-SS-260601-aXWsaxls",
        lat: 13.701270,
        lng: -89.224432,
        address: "Lorem ipsum dolor sit ammet",
        title: "A big pothole in the middle of the street",
        description: "There is a big pothole that is affecting our cars",
        severityId: 1,
        statusId: 1,
        issueTypeId: 1,
        matterToSolveId: 1,
        reportedAtRaw: nil,
        cellIndex: "",
        createdAtRaw: 1780036575602,
        updatedAtRaw: 1780036575602,
        reportedBy: "john.doe",
        cityId: "",
        petitionId: "",
        shareUrl: "",
//                    updatedAt
    )

    ScrollView {
        MoreInformationView(report: report)
    }
    .background(Color.theme.background)
}
