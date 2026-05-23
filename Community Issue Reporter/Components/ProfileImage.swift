//
//  ProfileImage.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/5/26.
//

import SwiftUI

struct ProfileImage: View {
    //    @State private var model: ReportDataModel
    
    
//    @State private var viewModel: ProfileDataModel
    var body: some View {
      
        
        Group {
            if let url = UserRepository.getProfilePictureURL() {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image("user_b")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "pencil.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    ProfileImage()
}
