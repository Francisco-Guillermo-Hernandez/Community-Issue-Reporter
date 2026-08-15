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
        HStack(spacing: .themeSpacing) {
            
            Group {
                
                VStack {
                    Text("Issue Type")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.issueType.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))

                VStack {
                    Text("Severity")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.severity.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))
      

                VStack {
                    Text("Status")
                        .font(.caption)
                        .opacity(opacity)

                    Text(report.status.title)
                        .font(.caption)
                        .fontWeight(.semibold)

                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: .themeRadius * 1.1, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    
    BasicInformationView(for: MapExplorerMockedData.shared.report)
}
