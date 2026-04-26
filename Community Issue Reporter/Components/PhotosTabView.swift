/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays the captured photos.
*/

import Photos
import SwiftUI

struct PhotosTabView: View {
    // The constant color UIImage.
    private var constantColorImage: UIImage?
    
    // The confidence map using the Core Video pixel buffer
    private var confidenceMap: UIImage?
    
    // The confidence level for the constant color photo.
//    private var confidenceLevel: Float?
    
    // The fallback photo UIImage.
    private var fallbackPhoto: UIImage?
    
    // The normal photo UIImage.
    private var normalPhoto: UIImage?
    
    // The selection integer for the tab view.
    @State private var selection: Int = 0
    
    // The environment variable to dismiss the photos tab view.
    @Environment(\.dismiss) private var dismiss
    
    // The view initializer for the photos tab view.
    init(normalPhoto: UIImage? = nil, constantColorImage: UIImage? = nil, fallbackPhoto: UIImage? = nil) {
        self.constantColorImage = constantColorImage
        self.fallbackPhoto = fallbackPhoto
        self.normalPhoto = normalPhoto
    }
    
    var body: some View {
        HStack {
            Spacer()
            // The Done button to dismiss the photos tab view.
            Button() {
                dismiss()
            } label: {
                Text("Done").foregroundStyle(.blue)
            }.padding(.trailing, 15)
        }
        NavigationStack {
            Group {
                if let normalPhoto = normalPhoto {
                   
                    ImageView(image: normalPhoto, textLabel: "")
                } else if let constantColorImage = constantColorImage {
                    
                        ImageView(image: constantColorImage, textLabel: "").tag(0)
                       
                } else if let fallbackPhoto {
                 
                        ImageView(image: fallbackPhoto, textLabel: "").tag(0)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .confirm) {
                        dismiss()
                    }
                }
            }
        }
    }
    
}

// The image view for the photos tab view.
struct ImageView: View {
    private var image: UIImage?
    private var text: String
        
    // The initializer for the image view.
    init(image: UIImage?, textLabel: String) {
        self.image = image
        self.text = textLabel
    }
    
    var body: some View {
        VStack {
            if let image {
                // The image and text views for the constant color photo, fallback photo, and normal photo.
                Text(text).padding(.bottom, 40).foregroundColor(.white)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(.bottom, 50)
            }
        }
        .background(.black)
    }
}

#Preview {
    PhotosTabView(normalPhoto: UIImage(systemName: "exclamationmark.circle.fill"))
}

