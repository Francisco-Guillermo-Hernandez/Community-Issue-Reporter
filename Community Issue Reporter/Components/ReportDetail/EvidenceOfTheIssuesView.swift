//
//  EvidenceOfTheIssuesView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI

struct EvidenceOfTheReportView: View {
    var attachments: [PreviewAttachment]
    var id: String
    
    init(_ attachments: [PreviewAttachment], id: String) {
        self.attachments = attachments
        self.id = id
//        self.attachments.append(
//            PreviewAttachment(id: "placeholder", type: .image, createdAtRaw: 0, updatedAtRaw: nil, uploaderUserName: "", validatedBy: .manually, state: .confirmed, fileName: "", reportContainer: "")
//        )
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "Evidence of the report"))
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 2) {
                    ForEach(attachments, id: \.id) { attachment in
                        
                        if attachment.more {
                            
                            NavigationLink(value: DetailNavigationDestination.moreEvidences(id)) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.theme.primary, lineWidth: 2)
                                    .frame(width: 160, height: 160)
                                    .foregroundStyle(
                                        Color(uiColor: .systemGray6)
                                    )
                                    .overlay {
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.stack")
                                                .foregroundStyle(
                                                    Color.theme.foreground
                                                )
                                                .font(.largeTitle)
                                            
                                            HStack {
                                                Text(String(localized: "More Evidences..."))
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                
                                                    .foregroundStyle(
                                                        Color.theme.foreground
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.trailing, 16)
                            }
                            
                        } else {
                            
                            photoPreview(attachment)
                                
                        }
                    }
                }
            }
            .padding(.leading, .themePadding)
            .scrollClipDisabled()
        }
    }
}

//#Preview {
//    evidenceOfTheIssuesView()
//}
