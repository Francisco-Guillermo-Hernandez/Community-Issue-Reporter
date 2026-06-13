//
//  EvidencesView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PhotosUI

struct EvidencesView: View {
    @State var orientation = UIDevice.current.orientation
    
    @State private var selectedImages: UIImage? = nil
    @State private var cameraCompletion: ((UIImage) -> Void)? = nil
    @State private var isCameraPresented: Bool = false
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a", published: Date(), user: "Jane Doe"),
        PhotoSample(id: "2", photo: "b", published: Date(), user: "John Smith"),
        PhotoSample(id: "3", photo: "c", published: Date(), user: "Michael Brown"),
        PhotoSample(id: "4", photo: "d", published: Date(), user: "Emily Davis"),
    ]
    
    @Namespace private var nameSpace
    @State private var previewID: String = ""
    
    var id: String
    
    init(with id: String) {
        self.id = id
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridColumns, spacing: 4) {
                ForEach(photos, id: \.id) { photo in
                    NavigationLink(value: photo) {
                        photoPreview(photo)
                            .matchedTransitionSource(id: photo.id, in: nameSpace)
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        previewID = photo.id
                    })
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationDestination(for: PhotoSample.self) { photo in
            PhotoDetailView(photos: photos, previewID: $previewID, nameSpace: nameSpace)
                .navigationTransition(.zoom(sourceID: previewID, in: nameSpace))
        }
        .scrollContentBackground(.hidden)
        .fullScreenCover(isPresented: $isCameraPresented) {
            ImagePicker(sourceType: .camera, onImagePicked: { resource in
                
                if let resource, let avatar = resource.data {
                    
                    onSelect(avatar)
                }
                
                cameraCompletion = nil
                isCameraPresented = false
            })
            .edgesIgnoringSafeArea(.all)
        }
        .toolbar {
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                
            
                
                PhotosPicker(
                    selection: $selectedPhotoItems,
                    maxSelectionCount: 1,
                    matching: .any(
                        of: [
                            .images,
                            .panoramas,
                            .not(.screenshots),
                            .not(.videos),
                            .not(.screenRecordings),
                            .not(.spatialMedia),
                        ]
                    )
                ) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.callout)

                }
                .accessibilityLabel("Add more Evidence from your Gallery")
                .onChange(of: selectedPhotoItems) { _, newItems in
                    guard !newItems.isEmpty else { return }
//                    viewModel.selectedAvatarOptionView = option.associatedView
                    loadSelectedImages(from: newItems) { image in
                        if let avatar = image {
                            onSelect(avatar)
                        }
                       
                    }
                }
                
                
                Button("Add more Evidence", systemImage: "camera") {
                    takePhotoUsingCamera { images in
                        onSelect(images)
                    }
                }
                .accessibilityLabel("Add more Evidences by taking a photo")
            }
            
            
        }
        .background(Color.theme.background)
        .toolbarTitleDisplayMode(.large)
        .navigationTitle("Evidences")
        .navigationSubtitle("You can take a look of what is happening")
    }
    
    fileprivate let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    
    private func takePhotoUsingCamera(onComplete: @escaping (UIImage) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        cameraCompletion = onComplete
        isCameraPresented = true
    }
    
    
    private func onSelect(_ image: UIImage) {
        Task {
            
            try? await Task.sleep(for: .milliseconds(128))
            dismiss()
        }
    }
    
    private func loadSelectedImages(from items: [PhotosPickerItem], onComplete: @escaping (UIImage?) -> Void) {
        Task {
            var image: UIImage?
           
            /// To UIImage
            if let data = try? await items[0].loadTransferable(type: Data.self) {
                image = UIImage(data: data)
            }

            await MainActor.run {
                onComplete(image)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EvidencesView(with: "")
    }
}
