//
//  MediaStepView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct MediaStepView: View {
    @Binding var media: [UIImage]
    @State private var selectedImages: [MediaResources] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            
            PhotoChooser(
                onSelect: { images in
                    print("Selected images: \(images.count)")
                    self.selectedImages = images
                },
                onDelete: { index in
                    self.selectedImages.remove(at: index)
                }
            )
        }
        .padding(.top, 4)
    }
}


#Preview {
    MediaStepView(media: .constant([]))
}
