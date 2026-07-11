//
//  PetitionViewPost.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct PetitionViewPost: View {
    var petition: PetitionPost
    @State private var opacity: Double = 0.85
    
    var body: some View {
        
        VStack(spacing: .themeSpacing * 3) {
            
            HStack(alignment: .top, spacing: .themeSpacing * 4) {
                
                VStack(alignment: .leading) {
                    Text(String(localized: "Category", comment: "Category text at petition list"))
                        .font(.caption)
                        .opacity(opacity)
                    
                    Text(getCategoryName(id: petition.categoryId))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                
                VStack(alignment: .leading) {
                    Text(String(localized: "Status", comment: "Status text at petition list"))
                        .font(.caption)
                        .opacity(opacity)
                    
                    Text(petition.status.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 4) {
                        ForEach(petition.attachments, id: \.id) { attachment in
                            PhotoPreview(attachment, height: 200, width: 200)
                        }
                    }
                }
                .scrollClipDisabled()
               
            }
            .frame(maxHeight: 200)
            
        }
    }
}

#Preview {
    
    
    ScrollView {
        PetitionViewPost(petition: PetitionsPostMockedData.shared.petitions[0])
            .containerRelativeFrame(.vertical)
    }
    .background(Color.theme.background)
}
