//
//  PhotoChooser.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PhotosUI

struct PhotoChooser: View {
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isCameraPresented: Bool
    @State private var cameraCompletion: (([UIImage]) -> Void)?
    @State private var previewImage: UIImage?
    @State private var isImagePreviewPresented: Bool
    
    var onSelect: ([UIImage]) -> Void
    var onDelete: (Int) -> Void
    
    init(onSelect:  @escaping ([UIImage]) -> Void, onDelete: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectedPhotoItems = []
        self.selectedImages = []
        self.isCameraPresented = false
        self.isImagePreviewPresented = false
    }
    
    var body: some View {
       
        
        Group {
            VStack {
                HStack(spacing: 16) {
                    Button {
                        takePhotoUsingCamera { images in
                            handleSelectedImages(images)
                        }
                    } label: {
                        Label("Camera", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .images) {
                        Label("Gallery", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        loadSelectedImages(from: newItems) { images in
                            handleSelectedImages(images)
                        }
                    }
                }
                
                Divider()
                    .padding(.bottom, 8)
                    .padding(.top, 8)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHStack(spacing: 12) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topLeading) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .contentShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        showPreview(for: selectedImages[index])
                                    }
                                    .onLongPressGesture(minimumDuration: 0.4) {
                                        triggerHaptic()
                                        showPreview(for: selectedImages[index])
                                    }
                                
                                Button {
                                    deleteImage(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(Font.headline.bold())
                                }
                                .padding(4)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .sheet(isPresented: $isCameraPresented) {
                ImagePicker(sourceType: .camera) { image in
                    if let image {
                        cameraCompletion?([image])
                    }
                    cameraCompletion = nil
                    isCameraPresented = false
                }
            }
            .fullScreenCover(isPresented: $isImagePreviewPresented) {
                
                if let previewImage {
                    ZStack {
                        BackgroundClearView()
                        Rectangle()
                            .opacity(0.3)
//                            .fill(.clear)
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                dismissPreview()
                            }
                        
                        GeometryReader { proxy in
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .shadow(radius: 16)
                                .contentShape(RoundedRectangle(cornerRadius: 32))
                                .frame(width: proxy.size.width - 32, height: proxy.size.height / 2)
                                .position(x: proxy.size.width / 2 , y: proxy.size.height / 2)
                                .onTapGesture {
                                    dismissPreview()
                                }
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: isImagePreviewPresented)
                }
               
            }
            if isImagePreviewPresented, let previewImage {
                ZStack {
//                    BackgroundClearView()
                    Rectangle()
                        .opacity(0)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            dismissPreview()
                        }
                    
                    GeometryReader { proxy in
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .shadow(radius: 16)
                            .contentShape(RoundedRectangle(cornerRadius: 32))
                            .frame(width: proxy.size.width - 32, height: proxy.size.height / 2)
                            .position(x: proxy.size.width / 2 , y: proxy.size.height / 2)
                            .onTapGesture {
                                dismissPreview()
                            }
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: isImagePreviewPresented)
            }
        }
    }
    
    
    
    private struct BackgroundClearView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                // Reach up the view hierarchy and clear the modal container’s background
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
    
    private func takePhotoUsingCamera(onComplete: @escaping ([UIImage]) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        cameraCompletion = onComplete
        isCameraPresented = true
    }
    
    private func handleSelectedImages(_ images: [UIImage]) {
        selectedImages = images
        // TODO: Send `images` to the upload service.
    }

    private func deleteImage(at index: Int) {
        guard selectedImages.indices.contains(index) else {
            return
        }

        selectedImages.remove(at: index)
    }

    private func showPreview(for image: UIImage) {
        previewImage = image
        isImagePreviewPresented = true
    }

    private func dismissPreview() {
        isImagePreviewPresented = false
        previewImage = nil
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    

    private func loadSelectedImages(
        from items: [PhotosPickerItem],
        onComplete: @escaping ([UIImage]
    ) -> Void) {
        Task {
            var images: [UIImage] = []
            images.reserveCapacity(items.count)

            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }

            await MainActor.run {
                onComplete(images)
            }
        }
    }
}


private struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            // Reach up the view hierarchy and clear the modal container’s background
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    PhotoChooser(
        onSelect: { _ in
            
        },
        onDelete: { _ in
        
        }
    )
}
