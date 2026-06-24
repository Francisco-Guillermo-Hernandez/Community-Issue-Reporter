//
//  MediaStepView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct MediaStepView: View {
    @Binding var selectedImages: [MediaResources]
    
    init(attachments: Binding<[MediaResources]>) {
        self._selectedImages = attachments
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 3) {
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
    NavigationStack {
        VStack {
            MediaStepView(attachments: .constant([]))
        }
        .padding()
        .background(Color.theme.background)
    }
    
}
