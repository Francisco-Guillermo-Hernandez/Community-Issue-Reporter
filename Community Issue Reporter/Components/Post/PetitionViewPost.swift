//
//  PetitionViewPost.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI

struct PetitionViewPost: View {
    var petition: Petition
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a", published: Date(), user: "Jane Doe"),
        PhotoSample(id: "2", photo: "b", published: Date(), user: "John Smith"),
        PhotoSample(
            id: "3",
            photo: "c",
            published: Date(),
            user: "Michael Brown"
        ),
        PhotoSample(
            id: "4",
            photo: "d",
            published: Date(),
            user: "Emily Davis"
        ),
    ]
    
    var body: some View {
        
        VStack(spacing: .themeSpacing * 3) {
            
            HStack(alignment: .top, spacing: .themeSpacing * 4) {
                
                VStack(alignment: .leading) {
                    Text(String(localized: "Category", comment: "Category text at petition list"))
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Text(getCategoryName(id: petition.categoryId))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                
                VStack(alignment: .leading) {
                    Text(String(localized: "Status", comment: "Status text at petition list"))
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Text(petition.status.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 4) {
                        ForEach(photos, id: \.id) { photo in
                            
                            Image(photo.photo)
                                .resizable()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .topLeading
                                )
                                .aspectRatio(4 / 3, contentMode: .fill)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: .themeRadius,
                                        style: .continuous
                                    )
                                )
                                .contentShape(
                                    RoundedRectangle(
                                        cornerRadius: .themeRadius,
                                        style: .continuous
                                    )
                                )
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
            
        }
    }
}

#Preview {
    let petition = Petition(
        id: "3",
        title: "Hay una fuga de agua en la colonia",
        description: "",
        targetSignatures: 22,
        currentSignatures: 0,
        categoryId: 4,
        statusId: 1,
        reportedBy: UUID(
            uuidString: "727DD4B3-6372-44A9-BD95-CD779BB5F290"
        ),
        disabled: false,
        createdAt: Date(timeIntervalSince1970: 799056444.493906),
        updatedAt: Date(timeIntervalSince1970: 799056444.493906),
        reportsIds: [
            "9032fc2b-feee-4bc9-be27-63b2200f2f2c",
            "51aec27c-17a3-42f5-94a7-b3e9f54be651",
            "1d4049ce-df9c-4a02-ae17-db3ba5ceedbd",
            "e6e67b15-15d7-4523-a85b-cd199d32117e",
            "d76caf4a-75ef-41b3-a27f-f5e38a894e8e",
            "ac90b962-3ea9-405e-8a5b-f99ba3b9439d",
        ]
    )
    
    PetitionViewPost(petition: petition)
}
