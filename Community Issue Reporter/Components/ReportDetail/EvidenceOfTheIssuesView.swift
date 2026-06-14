//
//  EvidenceOfTheIssuesView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 13/6/26.
//

import SwiftUI

struct EvidenceOfTheIssuesView: View {
    var photos: [PhotoSample]
    var id: String
    var body: some View {
        VStack {
            SectionHeader(title: String(localized: "Evidence of the report"))
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 2) {
                    ForEach(photos, id: \.id) { photo in
                        
                        if photo.more {
                            
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
                            
                            photoPreview(photo)
                                .frame(width: 160, height: 160)
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
