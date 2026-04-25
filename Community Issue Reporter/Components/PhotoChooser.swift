//
//  PhotoChooser.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PhotosUI

enum MediaTypes: String {
    case photo
    case image
    case video
}

enum DeviceOrientation: String {
    case landscape
    case portrait
}

struct BasicMetadata {
    let deviceOrientation: DeviceOrientation
}

struct MediaResources {
    let type: MediaTypes
    let data: UIImage?
    let metadata: BasicMetadata
}

struct PhotoChooser: View {
    @Namespace private var nameSpace
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [MediaResources] = []
    @State private var isCameraPresented: Bool
    @State private var cameraCompletion: (([MediaResources]) -> Void)?
    @State private var previewImage: UIImage?
    @State private var isImagePreviewPresented: Bool
    @State var orientation = UIDevice.current.orientation
    
    var onSelect: ([MediaResources]) -> Void
    var onDelete: (Int) -> Void
    
    init(onSelect:  @escaping ([MediaResources]) -> Void, onDelete: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectedPhotoItems = []
        self.selectedImages = []
        self.isCameraPresented = false
        self.isImagePreviewPresented = false
    }
    
    var body: some View {
       
        
        VStack {
            VStack {
                HStack(spacing: 16) {
                    Button {
                        takePhotoUsingCamera { images in
                            handleSelectedImages(images)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                                
                            Text("Take Photo")
                                .font(.callout.bold())
                               
                        }
                        .foregroundStyle(Color.theme.foreground)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.theme.muted)
                        )
                            
                    }
                    .buttonStyle(.borderless)
                    
                   
                    
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .images) {
                    
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                               
                            Text("Gallery")
                                .font(.callout.bold())
                        }
                        .foregroundStyle(Color.theme.foreground)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.theme.muted)
                        )
                    }
                    .buttonStyle(.borderless)
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
                    LazyHStack(spacing: .themeSpacing * 4) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topLeading) {
//                                GeometryReader { proxy in
                                Image(uiImage: selectedImages[index].data!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
//                                        .frame(width: proxy.size.width / 4, height: proxy.size.height / 4)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .contentShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                        .onTapGesture {
                                            showPreview(for: selectedImages[index].data!)
                                            
                                        }
                                        .onLongPressGesture(minimumDuration: 0.4) {
                                            triggerHaptic()
                                            showPreview(for: selectedImages[index].data!)
                                        }
                                        .matchedTransitionSource(id: "transition:openPreview", in: nameSpace)
                                        .sensoryFeedback(.impact(weight: .medium), trigger: isImagePreviewPresented)
//                                }
                                
                                Button {
                                    deleteImage(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(Font.headline.bold())
                                }
                                .offset(x: -16, y: -16)
                                .padding(4)
                            }
                            .aspectRatio(3/2, contentMode: .fill)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
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
                
                if isImagePreviewPresented, let previewImage {
                    ZStack {
//                        BackgroundClearView()
                        Rectangle()
                            .opacity(0.001)
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
                    .navigationTransition(.zoom(sourceID: "transition:openPreview", in: nameSpace))
//                    .transition(.opacity)
//                    .animation(.easeInOut(duration: 0.2), value: isImagePreviewPresented)
                }
               
            }
            if let previewImage {}
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
    
    private func takePhotoUsingCamera(onComplete: @escaping ([MediaResources]) -> Void) {
        isCameraPresented = true
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        cameraCompletion = onComplete
       
    }
    
    private func handleSelectedImages(_ images: [MediaResources]) {
        selectedImages = images
        onSelect(selectedImages)
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

    

    private func loadSelectedImages(from items: [PhotosPickerItem], onComplete: @escaping ([MediaResources]) -> Void) {
        Task {
            var images: [MediaResources] = []
            images.reserveCapacity(items.count)

            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(MediaResources(type: .photo, data: image, metadata: BasicMetadata(deviceOrientation: orientation.isPortrait ? .portrait: .landscape )))
                }
            }

            await MainActor.run {
                onComplete(images)
            }
        }
    }
}

//
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

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (MediaResources?) -> Void
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @State var orientation = UIDevice.current.orientation
        
        private let onImagePicked: (MediaResources?) -> Void

        init(onImagePicked: @escaping (MediaResources?) -> Void) {
            self.onImagePicked = onImagePicked
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImagePicked(nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            onImagePicked(MediaResources(type: .photo, data: image, metadata: BasicMetadata(deviceOrientation: orientation.isLandscape ? .landscape: .portrait)))
        }
    }
}
