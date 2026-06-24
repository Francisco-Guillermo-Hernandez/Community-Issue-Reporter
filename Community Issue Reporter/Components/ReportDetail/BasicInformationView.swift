//
//  BasicInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI

struct BasicInformationView: View {
    var report: MapExplorerReport
    private var opacity: Double = 0.85
    init(for report: MapExplorerReport) { self.report = report }
    var body: some View {
        HStack(spacing: .themeSpacing * 4) {

            
            Group {
                VStack {
                    Text("Reported at")
                        .font(.caption)
                        .opacity(opacity)
                        

                    Text(report.reportedDate)
                        .font(.caption)
                        .fontWeight(.semibold)

                }

                VStack {
                    Text("Issue Type")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.issueType.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                VStack {
                    Text("Severity")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.severity.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                VStack {
                    Text("Status")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.status.title)
                        .font(.caption)
                        .fontWeight(.semibold)

                }
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
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
        reportedBy: "John Doe",
        cityId: "",
        petitionId: "",
        shareUrl: "",
//                    updatedAt
    )
    BasicInformationView(for: report)
}
